import 'package:library_app/database/library_database.dart';
import 'package:library_app/models/score_with_details.dart';
import 'package:library_app/models/status.dart';

class SheetData {
  final Map<String, String> sheetData = {};

  SheetData({required ScoreWithDetails score}) {
    _convertScoreToSheetData(score);
  }

  void _convertScoreToSheetData(ScoreWithDetails score) {
    String title = score.score.title;
    String? composer = score.composer?.name;
    String arranger = score.score.arranger;
    String catalogNumber = score.score.catalogNumber;
    String? notes = score.score.notes;
    String? category = score.category?.name;
    Set<SubcategoryData>? subcategories = score.subcategories;
    Status? status = score.status;
    String? link = score.score.link;
    DateTime changeTime = score.score.changeTime;

    if (composer == null || category == null || status == null) {
      return;
    }

    if (title.isEmpty ||
        composer.isEmpty ||
        catalogNumber.isEmpty ||
        category.isEmpty) {
      return;
    }

    sheetData["title"] = title;
    sheetData["composer"] = composer;
    sheetData["arranger"] = arranger;
    sheetData["catalog number"] = catalogNumber;
    sheetData["notes"] = notes;
    sheetData["category"] = category;
    sheetData["subcategories"] = _parseSubcategories(subcategories);
    sheetData["status"] = status.title;
    sheetData["link"] = (link != null) ? link : "";
    sheetData["change time"] = changeTime.toString();
  }

  String _parseSubcategories(Set<SubcategoryData>? subcategories) {
    if (subcategories == null || subcategories.isEmpty) return '';
    final subCatList = [];
    for (final item in subcategories) {
      subCatList.add(item.name);
    }
    return subCatList.join(", ");
  }
}
