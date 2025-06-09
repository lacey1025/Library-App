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
}

class MissingHeaderException implements Exception {
  final List<String> missingHeaders;
  MissingHeaderException(this.missingHeaders);

  @override
  String toString() =>
      "MissingHeaderException: These headers are missing [${missingHeaders.join(', ')}]";
}
