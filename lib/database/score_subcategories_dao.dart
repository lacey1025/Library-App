import 'package:drift/drift.dart';
import 'package:library_app/database/library_database.dart';

part 'score_subcategories_dao.g.dart';

@DriftAccessor(tables: [ScoreSubcategories, Subcategories])
class ScoreSubcategoriesDao extends DatabaseAccessor<LibraryDatabase>
    with _$ScoreSubcategoriesDaoMixin {
  ScoreSubcategoriesDao(super.db);

  Future<List<SubcategoryData>> getSubcategoriesForScore(int scoreId) async {
    final query = select(subcategories).join([
      innerJoin(
        scoreSubcategories,
        scoreSubcategories.subcategoryId.equalsExp(subcategories.id),
      ),
    ])..where(scoreSubcategories.scoreId.equals(scoreId));

    final rows = await query.get();
    return rows.map((row) => row.readTable(subcategories)).toList();
  }

  Future<void> addSubcategoryToScore(int scoreId, int subcategoryId) async {
    await into(
      scoreSubcategories,
    ).insert(ScoreSubcategory(scoreId: scoreId, subcategoryId: subcategoryId));
  }

  Future<void> bulkInsertScoreSubcategory(
    List<ScoreSubcategoriesCompanion> links,
  ) async {
    if (links.isEmpty) return;

    await batch((batch) {
      batch.insertAll(
        scoreSubcategories,
        links,
        mode: InsertMode.insertOrIgnore,
      );
    });
  }

  Future<void> removeSubcategoryFromScore(
    int scoreId,
    int subcategoryId,
  ) async {
    await (delete(scoreSubcategories)..where(
      (s) => s.scoreId.equals(scoreId) & s.subcategoryId.equals(subcategoryId),
    )).go();
  }
}
