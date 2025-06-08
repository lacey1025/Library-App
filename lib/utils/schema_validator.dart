class ImportError {
  final int rowIndex;
  final String message;

  ImportError({required this.rowIndex, required this.message});

  @override
  String toString() => "Row $rowIndex: $message";
}

class RowValidator {
  final List<String> allowedStatuses = [
    'in library',
    'missing',
    'checked out',
    'incomplete',
    'in binders',
    'digital only',
  ];

  List<ImportError> validateRow(List<dynamic> row, int rowIndex) {
    final errors = <ImportError>[];

    final title = getCell(row, 0);
    final composer = getCell(row, 1);
    final catalogNumber = getCell(row, 3);
    final category = getCell(row, 5);
    final subCategories = getCell(row, 6);
    final status = getCell(row, 7);
    final changeTime = getCell(row, 9);

    if (title.isEmpty) {
      errors.add(ImportError(rowIndex: rowIndex, message: "Missing title."));
    }

    if (composer.isEmpty) {
      errors.add(ImportError(rowIndex: rowIndex, message: "Missing composer."));
    }

    if (catalogNumber.isEmpty) {
      errors.add(
        ImportError(rowIndex: rowIndex, message: "Missing catalog number"),
      );
    } else if (!RegExp(r'^[A-Za-z]+\d{1,4}$').hasMatch(catalogNumber)) {
      errors.add(
        ImportError(
          rowIndex: rowIndex,
          message:
              'Invalid catalog number format: "$catalogNumber". Use: "Text1234" (letters + up to 4 digits)',
        ),
      );
    }

    if (category.isEmpty) {
      errors.add(ImportError(rowIndex: rowIndex, message: "Missing category."));
    }

    if (status.isNotEmpty && !allowedStatuses.contains(status.toLowerCase())) {
      errors.add(
        ImportError(
          rowIndex: rowIndex,
          message:
              "Unknown status: '$status'. Must be one of: ${allowedStatuses.join(', ')}.",
        ),
      );
    } else if (status.isEmpty) {
      errors.add(ImportError(rowIndex: rowIndex, message: "Missing status."));
    }

    if (changeTime.isNotEmpty && DateTime.tryParse(changeTime) == null) {
      errors.add(
        ImportError(
          rowIndex: rowIndex,
          message: "Improperly formatted change time. Try deleting",
        ),
      );
    }
    if (subCategories.contains('/')) {
      errors.add(
        ImportError(
          rowIndex: rowIndex,
          message: "Please seperate subcategories with a comma",
        ),
      );
    }
    return errors;
  }

  String getCell(List row, int index) =>
      (index < row.length) ? row[index]?.toString().trim() ?? '' : '';
}
