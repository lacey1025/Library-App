import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:library_app/database/library_database.dart';
import 'package:library_app/utils/header_helper.dart';
import 'package:library_app/utils/highlight_error_cells.dart';
import 'package:library_app/utils/schema_validator.dart';

class GoogleSheetImporter {
  final String sheetId;
  final Map<String, String> authHeaders;
  final LibraryDatabase db;

  final List errorList = [];

  GoogleSheetImporter({
    required this.sheetId,
    required this.authHeaders,
    required this.db,
  });

  Future<List<ImportError>> importScores() async {
    final validator = RowValidator();
    final allErrors = <ImportError>[];
    final validRows = <List>[];

    await clearSheetFormatting(authHeaders, sheetId);
    final rows = await getSheetRows();

    if (rows == null) {
      return [
        ImportError(rowIndex: -1, message: "Sheet is empty or missing data."),
      ];
    }

    final headerRow = rows[0];
    final header = HeaderHelper(headerRow);
    final requiredHeaders = [
      'title',
      'composer',
      'arranger',
      'catalog number',
      'notes',
      'category',
      'subcategories',
      'status',
      'link',
      'change time',
    ];

    if (rows.isEmpty) {
      final addHeadersOK = await header.createInitialHeaders(
        sheetId: sheetId,
        authHeaders: authHeaders,
        initialHeaders: requiredHeaders,
      );
      if (addHeadersOK) {
        return [];
      } else {
        return [
          ImportError(
            rowIndex: -1,
            message: "Failed to add headers to empty sheet.",
          ),
        ];
      }
    }
    header.requireHeaders(requiredHeaders);

    if (rows.length < 2) return allErrors;

    final bodyRows = rows.sublist(1);
    final composersToInsert = <String>{};
    final categoriesToInsert = <String, String>{};

    for (int i = 0; i < bodyRows.length; i++) {
      final row = bodyRows[i];
      final rowIndex = i + 2;

      if (header.isRowEmpty(row, ['title', 'composer', 'catalog number'])) {
        continue;
      }

      final rowErrors = validator.validateRow(row, rowIndex, header);
      allErrors.addAll(rowErrors);

      if (rowErrors.isEmpty) {
        validRows.add(row);
        final composerName = header.getCell(row, 'composer');
        final categoryName = header.getCell(row, 'category');
        final catalogNumber = header.getCell(row, 'catalog number');

        if (composerName.cell.isNotEmpty) {
          composersToInsert.add(composerName.cell);
        }
        if (categoryName.cell.isNotEmpty && catalogNumber.cell.isNotEmpty) {
          final identifier = catalogNumber.cell.replaceAll(
            RegExp(r'[\d\s]'),
            '',
          );
          categoriesToInsert[categoryName.cell] = identifier;
        }
      }
    }

    await db.transaction(() async {
      await db.clearAllTables();
      final composerList = await db.scoresDao.bulkInsertComposers(
        composersToInsert,
      );
      final categoryList = await db.categoryDao.bulkInsertCategories(
        categoriesToInsert,
      );
      final composerMap = {for (var c in composerList) c.name: c.id};
      final categoryMap = {for (var c in categoryList) c.name: c.id};

      final scores = <ScoresCompanion>[];
      final subCatSet = <(String name, int categoryId)>{};
      final scoreSubCatLinks = <(String catalogNumber, String subCatName)>{};

      for (int i = 0; i < validRows.length; i++) {
        final row = validRows[i];
        final title = header.getCell(row, 'title');
        final composerName = header.getCell(row, 'composer');
        final arranger = header.getCell(row, 'arranger');
        final catalogNumber = header.getCell(row, 'catalog number');
        final notes = header.getCell(row, 'notes');
        final categoryName = header.getCell(row, 'category');
        final subCats = header.getCell(row, 'subcategories');
        final status = header.getCell(row, 'status');
        final link = header.getCell(row, 'link');
        final changeTimeCell = header.getCell(row, 'change time');
        final changeTime =
            (changeTimeCell.cell.isNotEmpty)
                ? DateTime.tryParse(changeTimeCell.cell) ?? DateTime.now()
                : DateTime.now();

        final composerId = composerMap[composerName.cell];
        final categoryId = categoryMap[categoryName.cell];

        if (composerId == null) {
          allErrors.add(
            ImportError(
              rowIndex: -1,
              cellIndex: -1,
              message:
                  "Could not link composer ${composerName.cell} to ${title.cell}. Please try again. If this keeps happening please report the issue",
            ),
          );
          continue;
        }

        if (categoryId == null) {
          allErrors.add(
            ImportError(
              rowIndex: -1,
              cellIndex: null,
              message:
                  "Could not link category ${categoryName.cell} to ${title.cell}. Please try again. If this keeps happening please report the issue",
            ),
          );
          continue;
        }

        final score = ScoresCompanion(
          title: Value(title.cell),
          composerId: Value(composerId),
          arranger: Value(arranger.cell),
          catalogNumber: Value(catalogNumber.cell),
          notes: Value(notes.cell),
          categoryId: Value(categoryId),
          status: Value(status.cell),
          link: Value(link.cell),
          changeTime: Value(changeTime),
        );

        scores.add(score);

        if (subCats.cell.isNotEmpty) {
          for (final s in subCats.cell.split(',')) {
            final trimmed = s.trim();
            subCatSet.add((trimmed, categoryId));
            scoreSubCatLinks.add((catalogNumber.cell.trim(), trimmed));
          }
        }
      }

      final subcategoriesToInsert =
          subCatSet
              .map(
                (e) => SubcategoriesCompanion(
                  name: Value(e.$1),
                  categoryId: Value(e.$2),
                ),
              )
              .toList();

      final subCategoryList = await db.categoryDao.bulkInserSubcategories(
        subcategoriesToInsert,
      );
      final insertedScores = await db.scoresDao.insertScoresBatch(scores);
      final subCatMap = {
        for (var sub in subCategoryList) (sub.name, sub.categoryId): sub.id,
      };

      final scoreMap = {
        for (var score in insertedScores)
          score.catalogNumber.trim(): (score.id, score.categoryId),
      };

      final links =
          scoreSubCatLinks
              .map((pair) {
                final catalogNumber = pair.$1.trim();
                final subCatName = pair.$2.trim();
                final entry = scoreMap[catalogNumber];
                if (entry == null) {
                  allErrors.add(
                    ImportError(
                      rowIndex: -1,
                      message:
                          "Could not find score for $catalogNumber. Please try again. If this keeps happening please report the issue",
                    ),
                  );
                  return null;
                }
                final (scoreId, categoryId) = entry;
                final subCatId = subCatMap[(subCatName, categoryId)];

                if (subCatId == null) {
                  allErrors.add(
                    ImportError(
                      rowIndex: -1,
                      message:
                          "Could not find subcategory '$subCatName'. Please try again. If this keeps happening please report the issue.",
                    ),
                  );
                  return null;
                }

                return ScoreSubcategoriesCompanion(
                  scoreId: Value(scoreId),
                  subcategoryId: Value(subCatId),
                );
              })
              .whereType<ScoreSubcategoriesCompanion>()
              .toList();

      await db.scoreSubcategoriesDao.bulkInsertScoreSubcategory(links);
    });

    final highlightErrors =
        allErrors
            .where((e) => (e.cellIndex != null && e.cellIndex! >= 0))
            .toList();
    if (highlightErrors.isNotEmpty) {
      try {
        await highlightCellsWithNotes(
          cells: highlightErrors,
          authHeaders: authHeaders,
          sheetId: sheetId,
        );
      } catch (e) {
        debugPrint("Highlight exception occured: $e");
        return allErrors;
      }
    }
    return allErrors;
  }

  Future<List<dynamic>?> getSheetRows() async {
    final url = Uri.parse(
      'https://sheets.googleapis.com/v4/spreadsheets/$sheetId/values/Sheet1!A1:J',
    );

    final response = await http.get(url, headers: authHeaders);
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch sheet data: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data['values'];
  }
}
