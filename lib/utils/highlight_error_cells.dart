import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:library_app/utils/schema_validator.dart';

Future<void> highlightCellsWithNotes({
  required List<ImportError> cells,
  required String sheetId,
  required Map<String, String> authHeaders,
}) async {
  final tabId = await getTabId(authHeaders, sheetId);
  final url = Uri.parse(
    'https://sheets.googleapis.com/v4/spreadsheets/$sheetId:batchUpdate',
  );

  final requests =
      cells.where((cell) => cell.cellIndex != null && cell.cellIndex! >= 0).map(
        (cell) {
          return {
            "repeatCell": {
              "range": {
                "sheetId": tabId,
                "startRowIndex": cell.rowIndex - 1,
                "endRowIndex": cell.rowIndex,
                "startColumnIndex": cell.cellIndex,
                "endColumnIndex": cell.cellIndex! + 1,
              },
              "cell": {
                "userEnteredFormat": {
                  "backgroundColor": {"red": 1.0, "green": 1.0, "blue": 0.6},
                },
                "note": cell.message,
              },
              "fields": "userEnteredFormat.backgroundColor,note",
            },
          };
        },
      ).toList();

  final res = await http.post(
    url,
    headers: authHeaders,
    body: jsonEncode({"requests": requests}),
  );

  if (res.statusCode >= 400) {
    throw Exception('Failed to apply highlights: ${res.body}');
  }
}

Future<int> getTabId(Map<String, String> authHeaders, String sheetId) async {
  final res = await http.get(
    Uri.parse('https://sheets.googleapis.com/v4/spreadsheets/$sheetId'),
    headers: authHeaders,
  );

  if (res.statusCode != 200) throw Exception('Failed to fetch sheet info');

  final data = jsonDecode(res.body);
  return data['sheets'][0]['properties']['sheetId'];
}

Future<void> clearSheetFormatting(
  Map<String, String> authHeaders,
  String sheetId,
) async {
  final url = Uri.parse(
    'https://sheets.googleapis.com/v4/spreadsheets/$sheetId:batchUpdate',
  );

  final tabId = await getTabId(authHeaders, sheetId);

  final batchRequest = {
    "requests": [
      {
        "repeatCell": {
          "range": {
            "sheetId":
                tabId, // You may need to replace this with your actual sheet ID
          },
          "cell": {
            "userEnteredFormat": {"backgroundColor": null, "textFormat": null},
            "note": null,
          },
          "fields": "userEnteredFormat.backgroundColor,note",
        },
      },
    ],
  };

  final response = await http.post(
    url,
    headers: {...authHeaders, 'Content-Type': 'application/json'},
    body: jsonEncode(batchRequest),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to clear sheet formatting: ${response.body}');
  }
}
