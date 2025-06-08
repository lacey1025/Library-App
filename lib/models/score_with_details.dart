import 'package:library_app/database/library_database.dart';
import 'package:library_app/models/status.dart';

class ScoreWithDetails {
  final ScoreData score;
  final ComposerData? composer;
  final CategoryData? category;
  final Set<SubcategoryData>? subcategories;
  Status? status;

  ScoreWithDetails({
    required this.score,
    this.composer,
    this.category,
    this.subcategories,
  }) {
    status = StatusExtension.fromTitle(score.status);
  }

  ScoreWithDetails clone() {
    return ScoreWithDetails(
      score: score,
      composer: composer,
      category: category,
      subcategories: subcategories != null ? {...subcategories!} : null,
    );
  }

  static String? catalogValidiator(String? value, CategoryData? category) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (category == null) {
      return 'Must select a category';
    }
    final regex = RegExp(r'^[A-Za-z]+\d{1,4}$');
    if (!regex.hasMatch(value)) {
      return 'Invalid format. Use: "Text1234" (letters + up to 4 digits)';
    }
    final valueIdentifier = value.substring(0, category.identifier.length);
    if (valueIdentifier.trim().toUpperCase() != category.identifier) {
      return '${category.name} numbers must start with ${category.identifier}';
    }
    return null;
  }
}
