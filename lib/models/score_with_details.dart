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
}
