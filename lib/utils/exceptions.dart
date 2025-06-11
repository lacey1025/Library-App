class MissingHeaderException implements Exception {
  final List<String> missingHeaders;
  MissingHeaderException(this.missingHeaders);

  @override
  String toString() =>
      "MissingHeaderException: These headers are missing [${missingHeaders.join(', ')}]";
}

class CatalogNumberConflictException implements Exception {
  final String catalogNumber;

  CatalogNumberConflictException(this.catalogNumber);

  @override
  String toString() =>
      'CatalogNumberConflictException: '
      'Catalog number "$catalogNumber" already exists.';
}
