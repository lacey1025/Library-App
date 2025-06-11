import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:library_app/utils/exceptions.dart';
import 'package:http/http.dart' as http;

class HeaderHelper {
  final Map<String, int> _headerMap;

  HeaderHelper(List<dynamic> headers)
    : _headerMap = {
        for (int i = 0; i < headers.length; i++)
          headers[i].toString().trim().toLowerCase(): i,
      };

  void requireHeaders(List<String> requiredHeaders) {
    List<String> missingHeaders = [];
    for (final header in requiredHeaders) {
      if (!_headerMap.containsKey(header.toLowerCase())) {
        missingHeaders.add(header);
      }
    }
    if (missingHeaders.isNotEmpty) {
      throw MissingHeaderException(missingHeaders);
    }
  }

  ({int index, String cell}) getCell(List row, String headerName) {
    final index = _headerMap[headerName.toLowerCase()];
    if (index == null) return (index: -1, cell: '');
    final cellValue =
        (index < row.length) ? row[index]?.toString().trim() ?? '' : '';
    return (index: index, cell: cellValue);
  }

  bool isRowEmpty(List row, List<String> headersToCheck) {
    return headersToCheck.every((h) => getCell(row, h).cell.isEmpty);
  }

  Future<bool> createInitialHeaders({
    required String sheetId,
    required Map<String, String> authHeaders,
    required List<String> initialHeaders,
  }) async {
    final url = Uri.parse(
      'https://sheets.googleapis.com/v4/spreadsheets/$sheetId/values/Sheet1!A1:J1:append?valueInputOption=RAW',
    );

    final response = await http.post(
      url,
      headers: authHeaders,
      body: jsonEncode({
        'values': [initialHeaders],
      }),
    );

    if (response.statusCode != 200) {
      debugPrint("Failed to write headers: ${response.body}");
      return false;
    }
    return true;
  }
}
