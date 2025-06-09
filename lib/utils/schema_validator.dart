import 'package:library_app/utils/header_helper.dart';

class ImportError {
  final int rowIndex;
  final int? cellIndex;
  final String message;

  ImportError({required this.rowIndex, this.cellIndex, required this.message});

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

  List<ImportError> validateRow(
    List<dynamic> row,
    int rowIndex,
    HeaderHelper header,
  ) {
    final errors = <ImportError>[];

    final title = header.getCell(row, 'title');
    final composer = header.getCell(row, 'composer');
    final catalogNumber = header.getCell(row, 'catalog number');
    final category = header.getCell(row, 'category');
    final subCategories = header.getCell(row, 'subcategories');
    final status = header.getCell(row, 'status');
    final changeTime = header.getCell(row, 'change time');

    if (title.cell.isEmpty) {
      errors.add(
        ImportError(
          rowIndex: rowIndex,
          cellIndex: title.index,
          message: "Missing title.",
        ),
      );
    }

    if (composer.cell.isEmpty) {
      errors.add(
        ImportError(
          rowIndex: rowIndex,
          cellIndex: composer.index,
          message: "Missing composer.",
        ),
      );
    }

    if (catalogNumber.cell.isEmpty) {
      errors.add(
        ImportError(
          rowIndex: rowIndex,
          cellIndex: catalogNumber.index,
          message: "Missing catalog number",
        ),
      );
    } else if (!RegExp(r'^[A-Za-z]+\d{1,4}$').hasMatch(catalogNumber.cell)) {
      errors.add(
        ImportError(
          rowIndex: rowIndex,
          cellIndex: catalogNumber.index,
          message:
              'Invalid catalog number format: "${catalogNumber.cell}".\nUse: "Text1234" (letters + up to 4 digits)',
        ),
      );
    }

    if (category.cell.isEmpty) {
      errors.add(
        ImportError(
          rowIndex: rowIndex,
          cellIndex: category.index,
          message: "Missing category.",
        ),
      );
    }

    if (status.cell.isNotEmpty &&
        !allowedStatuses.contains(status.cell.toLowerCase())) {
      errors.add(
        ImportError(
          rowIndex: rowIndex,
          cellIndex: status.index,
          message:
              'Unknown status: "${status.cell}".\nMust be one of: ${allowedStatuses.join(', ')}.',
        ),
      );
    } else if (status.cell.isEmpty) {
      errors.add(
        ImportError(
          rowIndex: rowIndex,
          cellIndex: status.index,
          message: "Missing status.",
        ),
      );
    }

    if (changeTime.cell.isNotEmpty &&
        DateTime.tryParse(changeTime.cell) == null) {
      errors.add(
        ImportError(
          rowIndex: rowIndex,
          cellIndex: changeTime.index,
          message: "Improperly formatted change time. Try deleting",
        ),
      );
    }
    if (subCategories.cell.contains('/')) {
      errors.add(
        ImportError(
          rowIndex: rowIndex,
          cellIndex: subCategories.index,
          message: "Please separate subcategories with a comma.",
        ),
      );
    }

    return errors;
  }
}
