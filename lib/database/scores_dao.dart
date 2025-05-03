import 'package:drift/drift.dart';
import 'package:library_app/models/score_with_details.dart';
import 'library_database.dart';

part 'scores_dao.g.dart';

@DriftAccessor(
  tables: [Scores, Composers, Categories, ScoreSubcategories, Subcategories],
)
class ScoresDao extends DatabaseAccessor<LibraryDatabase>
    with _$ScoresDaoMixin {
  ScoresDao(super.db);

  Future<List<ScoreWithDetails>> getAllScores() async {
    final query = select(scores).join([
      leftOuterJoin(composers, composers.id.equalsExp(scores.composerId)),
      leftOuterJoin(categories, categories.id.equalsExp(scores.categoryId)),
      leftOuterJoin(
        scoreSubcategories,
        scoreSubcategories.scoreId.equalsExp(scores.id),
      ),
      leftOuterJoin(
        subcategories,
        subcategories.id.equalsExp(scoreSubcategories.subcategoryId),
      ),
    ]);
    final rows = await query.get();
    final scoreMap = <int, ScoreWithDetails>{};

    for (final row in rows) {
      final scoreData = row.readTable(scores);
      final composerData = row.readTableOrNull(composers);
      final categoryData = row.readTableOrNull(categories);
      final subcategoryData = row.readTableOrNull(subcategories);

      if (!scoreMap.containsKey(scoreData.id)) {
        scoreMap[scoreData.id] = ScoreWithDetails(
          score: scoreData,
          composer: composerData,
          category: categoryData,
          subcategories: <SubcategoryData>{},
        );
      }
      if (subcategoryData != null) {
        scoreMap[scoreData.id]?.subcategories!.add(subcategoryData);
      }
    }
    return scoreMap.values.toList();
  }

  Future<ScoreWithDetails> getScoreById(int id) async {
    final query = select(scores).join([
      leftOuterJoin(composers, composers.id.equalsExp(scores.composerId)),
      leftOuterJoin(categories, categories.id.equalsExp(scores.categoryId)),
      leftOuterJoin(
        scoreSubcategories,
        scoreSubcategories.scoreId.equalsExp(scores.id),
      ),
      leftOuterJoin(
        subcategories,
        subcategories.id.equalsExp(scoreSubcategories.subcategoryId),
      ),
    ])..where(scores.id.equals(id));
    final rows = await query.get();
    if (rows.isEmpty) {
      throw Exception("Score with ID $id not found");
    }
    ScoreWithDetails? scoreDetails;
    for (final row in rows) {
      final scoreData = row.readTable(scores);
      final composerData = row.readTableOrNull(composers);
      final categoryData = row.readTableOrNull(categories);
      final subcategoryData = row.readTableOrNull(subcategories);

      scoreDetails ??= ScoreWithDetails(
        score: scoreData,
        composer: composerData,
        category: categoryData,
        subcategories: <SubcategoryData>{},
      );
      if (subcategoryData != null) {
        scoreDetails.subcategories!.add(subcategoryData);
      }
    }
    return scoreDetails!;
  }

  Future<ScoreWithDetails> insertOrUpdateScore(
    int? id,
    ScoresCompanion score,
    Set<SubcategoryData>? subcategories,
  ) async {
    late int finalId;
    await transaction(() async {
      if (id == null) {
        finalId = await into(
          scores,
        ).insertReturning(score).then((row) => row.id);
      } else {
        finalId = id;
        await (update(scores)..where((s) => s.id.equals(id))).write(score);
      }

      if (subcategories != null) {
        await (delete(scoreSubcategories)
          ..where((s) => s.scoreId.equals(finalId))).go();

        await batch((batch) {
          batch.insertAll(
            scoreSubcategories,
            subcategories.map(
              (subcategory) => ScoreSubcategoriesCompanion.insert(
                scoreId: finalId,
                subcategoryId: subcategory.id,
              ),
            ),
          );
        });
      }
    });
    return await getScoreById(finalId);
  }

  Future<void> deleteScore(int id) async {
    return transaction(() async {
      await (delete(scoreSubcategories)
        ..where((s) => s.scoreId.equals(id))).go();
      await (delete(scores)..where((s) => s.id.equals(id))).go();
    });
  }

  Future<void> deleteScoreSubcategories(int scoreId) async {
    await (delete(scoreSubcategories)
      ..where((s) => s.scoreId.equals(scoreId))).go();
  }

  Future<ComposerData?> getComposerByName(String name) async {
    return await (select(composers)
      ..where((c) => c.name.equals(name))).getSingleOrNull();
  }

  Future<ComposerData> addComposer(String name) async {
    return await into(
      composers,
    ).insertReturning(ComposersCompanion(name: Value(name)));
  }

  // Returns a string representation of the next available catalog number
  Future<String> getNewCatalogNumber(int categoryId) async {
    final query = (select(scores)
          ..where((s) => s.categoryId.equals(categoryId))
          ..orderBy([(s) => OrderingTerm.desc(s.catalogNumber)])
          ..limit(1))
        .map((row) => row.catalogNumber);
    final result = await query.getSingleOrNull();
    return (result == null) ? "0001" : (result + 1).toString().padLeft(4, '0');
  }

  Future<bool> checkCatalogNumber(int catalogNumber, int categoryId) async {
    final query = select(scores)..where(
      (s) =>
          s.categoryId.equals(categoryId) &
          s.catalogNumber.equals(catalogNumber),
    );
    final existingCatalog = await query.getSingleOrNull();
    return existingCatalog == null;
  }
}
