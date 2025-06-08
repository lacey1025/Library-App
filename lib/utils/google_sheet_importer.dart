import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;
import 'package:library_app/database/library_database.dart';
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
    final validRowIndexes = <int>[];

    final url = Uri.parse(
      'https://sheets.googleapis.com/v4/spreadsheets/$sheetId/values/Sheet1!A2:J',
    );

    final response = await http.get(url, headers: authHeaders);
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch sheet data: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final List<dynamic>? rows = data['values'];
    if (rows == null || rows.isEmpty) {
      allErrors.add(
        ImportError(
          rowIndex: -1,
          message: "Spreadsheet is empty or an error importing occurred.",
        ),
      );
      return allErrors;
    }

    await db.transaction(() async {
      final composersToInsert = <String>{};
      final categoriesToInsert = <String, String>{};

      for (int i = 0; i < rows.length; i++) {
        final row = rows[i];
        if (isRowEmpty(row)) {
          continue;
        }

        final rowErrors = validator.validateRow(row, i + 2);
        allErrors.addAll(rowErrors);

        if (rowErrors.isEmpty) {
          validRowIndexes.add(i);
          final composerName = getCell(row, 1);
          final categoryName = getCell(row, 5);
          final catalogNumber = getCell(row, 3);

          if (composerName.isNotEmpty) composersToInsert.add(composerName);
          if (categoryName.isNotEmpty && catalogNumber.isNotEmpty) {
            final identifier = catalogNumber.replaceAll(RegExp(r'[\d\s]'), '');
            categoriesToInsert[categoryName] = identifier;
          }
        }
      }

      final [composerList, categoryList] =
          await Future.wait([
                db.scoresDao.bulkInsertComposers(composersToInsert),
                db.categoryDao.bulkInsertCategories(categoriesToInsert),
              ])
              as List<List<dynamic>>;

      final composerMap = {for (var c in composerList) c.name: c.id};
      final categoryMap = {for (var c in categoryList) c.name: c.id};

      final scores = <ScoresCompanion>[];
      final subCatSet = <(String name, int categoryId)>{};
      final scoreSubCatLinks = <(String catalogNumber, String subCatName)>{};

      for (final i in validRowIndexes) {
        final row = rows[i];

        final title = getCell(row, 0);
        final composerName = getCell(row, 1);
        final arranger = getCell(row, 2);
        final catalogNumber = getCell(row, 3);
        final notes = getCell(row, 4);
        final categoryName = getCell(row, 5);
        final subCats = getCell(row, 6);
        final status = getCell(row, 7);
        final link = getCell(row, 8);
        final changeTime = DateTime.tryParse(getCell(row, 9)) ?? DateTime.now();

        final composerId = composerMap[composerName];
        final categoryId = categoryMap[categoryName];

        final score = ScoresCompanion(
          title: Value(title),
          composerId: Value(composerId),
          arranger: Value(arranger),
          catalogNumber: Value(catalogNumber),
          notes: Value(notes),
          categoryId: Value(categoryId),
          status: Value(status),
          link: Value(link),
          changeTime: Value(changeTime),
        );

        scores.add(score);

        if (subCats.isNotEmpty) {
          for (final s in subCats.split(',')) {
            final trimmed = s.trim();
            subCatSet.add((trimmed, categoryId));
            scoreSubCatLinks.add((catalogNumber.trim(), trimmed));
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

      final [subCategoryList, insertedScores] =
          await Future.wait([
                db.categoryDao.bulkInserSubcategories(subcategoriesToInsert),
                db.scoresDao.insertScoresBatch(scores),
              ])
              as List<List<dynamic>>;

      final subCatMap = {
        for (var sub in subCategoryList) (sub.name, sub.categoryId): sub.id,
      };

      final scoreMap = {
        for (var score in insertedScores)
          if (score.catalogNumber != null) score.catalogNumber.trim(): score.id,
      };

      // === 6. Build links safely with detailed debug and safe checks ===

      final links =
          scoreSubCatLinks
              .map((pair) {
                final catalogNumber = pair.$1;
                final subCatName = pair.$2.trim();

                // Find the score companion by catalog number
                dynamic score;
                try {
                  score = scores.firstWhere(
                    (s) => s.catalogNumber.value == catalogNumber,
                  );
                } catch (e) {
                  score = null;
                }

                if (score == null) {
                  allErrors.add(
                    ImportError(
                      rowIndex: -1,
                      message: "Error adding subcategory '$subCatName'",
                    ),
                  );
                  return null;
                }

                final scoreId = scoreMap[catalogNumber];
                if (scoreId == null) {
                  allErrors.add(
                    ImportError(
                      rowIndex: -1,
                      message:
                          "Error adding subcategory '$subCatName' to '$catalogNumber'",
                    ),
                  );
                  return null;
                }

                final categoryId = score.categoryId.value;
                if (categoryId == null) {
                  allErrors.add(
                    ImportError(
                      rowIndex: -1,
                      message: "Error adding category to '$catalogNumber'",
                    ),
                  );
                  return null;
                }

                final subCatId = subCatMap[(subCatName, categoryId)];
                if (subCatId == null) {
                  allErrors.add(
                    ImportError(
                      rowIndex: -1,
                      message:
                          "Error adding subcategory '$subCatName' to category",
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
    for (final err in allErrors) {
      print("Error row: ${err.rowIndex}, Message: ${err.message}");
    }
    return allErrors;
  }

  bool isRowEmpty(List row) {
    // Only consider the first 3 fields for "emptiness"
    for (int i = 0; i < 3; i++) {
      final value = (i < row.length) ? row[i]?.toString().trim() ?? '' : '';
      if (value.isNotEmpty) return false;
    }
    return true;
  }

  String getCell(List row, int index) =>
      (index < row.length) ? row[index]?.toString().trim() ?? '' : '';
}
