import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:library_app/database/library_database.dart';
import 'package:library_app/models/sheet_data.dart';
import 'package:library_app/providers/app_initializer.dart';
import 'package:library_app/providers/database_provider.dart';
import 'package:library_app/providers/session_provider.dart';
import 'package:library_app/utils/exceptions.dart';
import 'package:library_app/utils/header_helper.dart';
import 'package:library_app/utils/highlight_error_cells.dart';
import 'package:library_app/utils/schema_validator.dart';

class GoogleSheetHelper {
  final String sheetId;
  final Map<String, String> authHeaders;
  final LibraryDatabase db;

  HeaderHelper? _headerHelper;
  final _validator = RowValidator();
  final List<ImportError> _allErrors = [];
  final _rows = [];
  final _validRows = <List>[];

  GoogleSheetHelper({
    required this.sheetId,
    required this.authHeaders,
    required this.db,
  });

  static Future<GoogleSheetHelper> fromRef(WidgetRef ref) async {
    final session = await ref.read(sessionProvider.future);
    if (session == null) {
      throw AddToSheetException("Missing session info");
    }

    final signIn = ref.read(googleSignInProvider);
    final googleAccount = await signIn.signInSilently();
    if (googleAccount == null) {
      throw AddToSheetException("Google account not available");
    }
    final authHeaders = await googleAccount.authHeaders;

    final db = ref.read(databaseProvider);

    return GoogleSheetHelper(
      sheetId: session.sheetId,
      authHeaders: authHeaders,
      db: db,
    );
  }

  Future<List<ImportError>> importScores() async {
    final headersOK = await _importAndSetupHeaders();
    if (!headersOK) return _allErrors;
    final result = await _validateAndParse();
    Set<String> composersToInsert;
    Map<String, String> categoriesToInsert;

    if (result != null) {
      composersToInsert = result.composers;
      categoriesToInsert = result.categories;
    } else {
      _allErrors.add(
        ImportError(rowIndex: -1, message: "Failed to get headers."),
      );
      return _allErrors;
    }

    await db.transaction(() async {
      await db.clearAllTables();
      final compCatResult = await _insertComposersCategories(
        composersToInsert,
        categoriesToInsert,
      );
      final composerMap = compCatResult.composerMap;
      final categoryMap = compCatResult.categoryMap;

      final scoresResult = await _setupScores(composerMap, categoryMap);
      await _addScoresSubcat(
        scoresResult.scores,
        scoresResult.subCatSet,
        scoresResult.scoreSubCatLinks,
      );
    });
    await _highlightResults();

    return _allErrors;
  }

  Future<void> insertOrUpdate({
    required SheetData rowData,
    String? oldCatNum,
  }) async {
    final catalogNumber =
        (oldCatNum == null) ? rowData.sheetData["catalog number"] : oldCatNum;

    if (catalogNumber == null || catalogNumber.isEmpty) {
      throw AddToSheetException("Could not get catalog number from sheet data");
    }

    final rowIndex = await _findRowIdxByCatalogNum(catalogNumber);

    final valuesToUpload = _headerHelper!.orderByHeaderOrder(
      sheetData: rowData,
    );

    if (valuesToUpload == null) {
      throw AddToSheetException("Failed to match score to sheet");
    }

    if (rowIndex != null) {
      await _updateRow(rowIndex: rowIndex, rowData: valuesToUpload);
    } else {
      await _appendRow(valuesToUpload);
    }
  }

  Future<void> deleteRow({required String catalogNumber}) async {
    final rowIndex = await _findRowIdxByCatalogNum(catalogNumber);
    final tabId = await getTabId(authHeaders, sheetId);
    if (rowIndex == null) {
      throw AddToSheetException("Score has already been deleted.");
    }
    final url = Uri.parse(
      'https://sheets.googleapis.com/v4/spreadsheets/$sheetId:batchUpdate',
    );
    final body = {
      "requests": [
        {
          "deleteDimension": {
            "range": {
              "sheetId": tabId,
              "dimension": "ROWS",
              "startIndex": rowIndex - 1,
              "endIndex": rowIndex,
            },
          },
        },
      ],
    };

    final response = await http.post(
      url,
      headers: authHeaders,
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw AddToSheetException("Failed to delete row. Please try again");
    }
  }

  Future<bool> _importAndSetupHeaders() async {
    await clearSheetFormatting(authHeaders, sheetId);
    final rows = await _getSheetRows();

    if (rows == null) {
      _allErrors.add(
        ImportError(rowIndex: -1, message: "Sheet is empty or missing data."),
      );
      return false;
    }
    _rows.addAll(rows);
    final headerRow = rows[0];
    _headerHelper = HeaderHelper(headerRow);
    if (_headerHelper == null) return false;
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

    if (_rows.isEmpty) {
      final addHeadersOK = await _headerHelper!.createInitialHeaders(
        sheetId: sheetId,
        authHeaders: authHeaders,
        initialHeaders: requiredHeaders,
      );
      if (addHeadersOK) {
        return true;
      } else {
        _allErrors.add(
          ImportError(
            rowIndex: -1,
            message: "Failed to add headers to empty sheet.",
          ),
        );
        return false;
      }
    }
    _headerHelper!.requireHeaders(requiredHeaders);

    if (rows.length < 2) return false;
    return true;
  }

  Future<({Set<String> composers, Map<String, String> categories})?>
  _validateAndParse() async {
    final bodyRows = _rows.sublist(1);
    final composersToInsert = <String>{};
    final categoriesToInsert = <String, String>{};

    if (_headerHelper == null) return null;

    for (int i = 0; i < bodyRows.length; i++) {
      final row = bodyRows[i];
      final rowIndex = i + 2;

      if (_headerHelper!.isRowEmpty(row, [
        'title',
        'composer',
        'catalog number',
      ])) {
        continue;
      }

      final rowErrors = _validator.validateRow(row, rowIndex, _headerHelper!);
      _allErrors.addAll(rowErrors);

      if (rowErrors.isEmpty) {
        _validRows.add(row);
        final composerName = _headerHelper!.getCell(row, 'composer');
        final categoryName = _headerHelper!.getCell(row, 'category');
        final catalogNumber = _headerHelper!.getCell(row, 'catalog number');

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
    return (composers: composersToInsert, categories: categoriesToInsert);
  }

  Future<({Map<String, int> composerMap, Map<String, int> categoryMap})>
  _insertComposersCategories(
    Set<String> composersToInsert,
    Map<String, String> categoriesToInsert,
  ) async {
    final composerList = await db.scoresDao.bulkInsertComposers(
      composersToInsert,
    );
    final categoryList = await db.categoryDao.bulkInsertCategories(
      categoriesToInsert,
    );
    final composerMap = {for (var c in composerList) c.name: c.id};
    final categoryMap = {for (var c in categoryList) c.name: c.id};
    return (composerMap: composerMap, categoryMap: categoryMap);
  }

  Future<
    ({
      Set<(String, int)> subCatSet,
      List<ScoresCompanion> scores,
      Set<(String, String)> scoreSubCatLinks,
    })
  >
  _setupScores(
    Map<String, int> composerMap,
    Map<String, int> categoryMap,
  ) async {
    final scores = <ScoresCompanion>[];
    final subCatSet = <(String name, int categoryId)>{};
    final scoreSubCatLinks = <(String catalogNumber, String subCatName)>{};

    for (int i = 0; i < _validRows.length; i++) {
      final row = _validRows[i];
      final title = _headerHelper!.getCell(row, 'title');
      final composerName = _headerHelper!.getCell(row, 'composer');
      final arranger = _headerHelper!.getCell(row, 'arranger');
      final catalogNumber = _headerHelper!.getCell(row, 'catalog number');
      final notes = _headerHelper!.getCell(row, 'notes');
      final categoryName = _headerHelper!.getCell(row, 'category');
      final subCats = _headerHelper!.getCell(row, 'subcategories');
      final status = _headerHelper!.getCell(row, 'status');
      final link = _headerHelper!.getCell(row, 'link');
      final changeTimeCell = _headerHelper!.getCell(row, 'change time');
      final changeTime =
          (changeTimeCell.cell.isNotEmpty)
              ? DateTime.tryParse(changeTimeCell.cell) ?? DateTime.now()
              : DateTime.now();

      final composerId = composerMap[composerName.cell];
      final categoryId = categoryMap[categoryName.cell];

      if (composerId == null) {
        _allErrors.add(
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
        _allErrors.add(
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
        catalogNumber: Value(catalogNumber.cell.toUpperCase().trim()),
        notes: Value(notes.cell),
        categoryId: Value(categoryId),
        status: Value(status.cell.toLowerCase().trim()),
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
    return (
      scores: scores,
      subCatSet: subCatSet,
      scoreSubCatLinks: scoreSubCatLinks,
    );
  }

  Future<void> _addScoresSubcat(
    List<ScoresCompanion> scores,
    Set<(String, int)> subCatSet,
    Set<(String, String)> scoreSubCatLinks,
  ) async {
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
                _allErrors.add(
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
                _allErrors.add(
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
  }

  Future<void> _highlightResults() async {
    final highlightErrors =
        _allErrors
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
      }
    }
  }

  Future<List<dynamic>?> _getSheetRows() async {
    final url = Uri.parse(
      'https://sheets.googleapis.com/v4/spreadsheets/$sheetId/values/Sheet1!A1:J',
    );

    final response = await http.get(url, headers: authHeaders);
    if (response.statusCode != 200) {
      throw AddToSheetException('Failed to fetch sheet data');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data['values'];
  }

  Future<int?> _findRowIdxByCatalogNum(String catalogNumber) async {
    final rows = await _getSheetRows();
    if (rows == null) {
      throw AddToSheetException("Failed to fetch sheet data");
    }
    final headers = rows[0];
    final body = rows.sublist(1);
    _headerHelper = HeaderHelper(headers);
    if (_headerHelper == null) {
      throw AddToSheetException("Could not get headers");
    }

    for (int i = 0; i < body.length; i++) {
      final row = body[i];
      final cell = _headerHelper!.getCell(row, "catalog number");
      if (cell.cell == catalogNumber) {
        return i + 2;
      }
    }
    return null;
  }

  Future<void> _updateRow({
    required int rowIndex,
    required List<String> rowData,
  }) async {
    final range = 'Sheet1!A$rowIndex:J$rowIndex';
    final url = Uri.parse(
      'https://sheets.googleapis.com/v4/spreadsheets/$sheetId/values/$range?valueInputOption=USER_ENTERED',
    );

    final response = await http.put(
      url,
      headers: {...authHeaders, 'Content-Type': 'application/json'},
      body: jsonEncode({
        'range': range,
        'majorDimension': 'ROWS',
        'values': [rowData],
      }),
    );

    if (response.statusCode != 200) {
      throw AddToSheetException('Failed to update row.');
    }
  }

  Future<void> _appendRow(List<String> rowData) async {
    final url = Uri.parse(
      'https://sheets.googleapis.com/v4/spreadsheets/$sheetId/values/Sheet1!A:J:append?valueInputOption=USER_ENTERED',
    );

    final response = await http.post(
      url,
      headers: {...authHeaders, 'Content-Type': 'application/json'},
      body: jsonEncode({
        'values': [rowData],
      }),
    );

    if (response.statusCode != 200) {
      throw AddToSheetException('Failed to insert row');
    }
  }
}
