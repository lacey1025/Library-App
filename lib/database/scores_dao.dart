import 'package:drift/drift.dart';
import 'package:drift/native.dart';
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

  Future<List<ScoreData>> insertScoresBatch(
    List<ScoresCompanion> scoresList,
  ) async {
    if (scoresList.isEmpty) {
      return [];
    }

    final buffer = StringBuffer();
    final args = <Object?>[];

    final columns = [
      'title',
      'composer_id',
      'arranger',
      'catalog_number',
      'notes',
      'category_id',
      'status',
      'link',
      'change_time',
    ];

    buffer.write('INSERT INTO scores (');
    buffer.write(columns.join(', '));
    buffer.write(') VALUES ');

    for (int i = 0; i < scoresList.length; i++) {
      final s = scoresList[i];
      if (i != 0) buffer.write(', ');

      buffer.write('(');
      buffer.write(List.filled(columns.length, '?').join(', '));
      buffer.write(')');

      args.addAll([
        s.title.value,
        s.composerId.value,
        s.arranger.present ? s.arranger.value : "",
        s.catalogNumber.value,
        s.notes.present ? s.notes.value : "",
        s.categoryId.value,
        s.status.value,
        s.link.present ? s.link.value : null,
        s.changeTime.present ? s.changeTime.value : DateTime.now(),
      ]);
    }

    buffer.write(' RETURNING *;');

    try {
      final results =
          await customSelect(
            buffer.toString(),
            variables: args.map((v) => Variable(v)).toList(),
            readsFrom: {scores},
          ).get();

      return results.map((row) {
        final data = row.data;
        return ScoreData(
          id: data['id'] as int,
          title: data['title'] as String,
          composerId: data['composer_id'] as int,
          arranger: data['arranger'] as String,
          catalogNumber: data['catalog_number'] as String,
          notes: data['notes'] as String,
          categoryId: data['category_id'] as int,
          status: data['status'] as String,
          link: data['link'] as String?,
          changeTime: DateTime.fromMillisecondsSinceEpoch(
            (data['change_time'] as int) * 1000,
          ),
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<ComposerData?> getComposerByName(String name) async {
    return await (select(composers)
      ..where((c) => c.name.equals(name))).getSingleOrNull();
  }

  Future<ComposerData> addComposer(String name) async {
    try {
      return await into(
        composers,
      ).insertReturning(ComposersCompanion(name: Value(name)));
    } on SqliteException catch (e) {
      if (e.message.contains('UNIQUE constraint failed')) {
        return await (select(composers)
          ..where((c) => c.name.equals(name))).getSingle();
      }
      rethrow;
    }
  }

  Future<List<ComposerData>> getAllComposers() async {
    return select(composers).get();
  }

  Future<List<ComposerData>> bulkInsertComposers(Set<String> names) async {
    if (names.isEmpty) return [];
    await batch((batch) {
      batch.insertAll(
        composers,
        names.map((n) => ComposersCompanion(name: Value(n))).toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
    return await (select(composers)
      ..where((c) => c.name.isIn(names.toList()))).get();
  }

  // Returns a string representation of the next available catalog number
  // Future<String> getNewCatalogNumber(int categoryId) async {
  //   final query = (select(scores)
  //         ..where((s) => s.categoryId.equals(categoryId))
  //         ..orderBy([(s) => OrderingTerm.desc(s.catalogNumber)])
  //         ..limit(1))
  //       .map((row) => row.catalogNumber);
  //   final result = await query.getSingleOrNull();
  //   return (result == null) ? "0001" : (result + 1).toString().padLeft(4, '0');
  // }
  Future<String> getNewCatalogNumber(int categoryId, String identifier) async {
    final query = (select(scores)..where(
      (s) => s.categoryId.equals(categoryId),
    )).map((row) => row.catalogNumber);

    final results = await query.get();

    final numbers =
        results
            .map((c) => int.tryParse(c.substring(identifier.length)))
            .whereType<int>();
    final highest =
        numbers.isEmpty ? 0 : numbers.reduce((a, b) => a > b ? a : b);

    final newNumber = (highest + 1).toString().padLeft(4, '0');
    return '$identifier$newNumber';
  }

  Future<bool> checkCatalogNumber(String catalogNumber, int categoryId) async {
    final query = select(scores)..where(
      (s) =>
          s.categoryId.equals(categoryId) &
          s.catalogNumber.equals(catalogNumber),
    );
    final existingCatalog = await query.getSingleOrNull();
    return existingCatalog == null;
  }

  //   Future<bool> checkCatalogNumber(int catalogNumber, int categoryId) async {
  //     final query = select(scores)..where(
  //       (s) =>
  //           s.categoryId.equals(categoryId) &
  //           s.catalogNumber.equals(catalogNumber),
  //     );
  //     final existingCatalog = await query.getSingleOrNull();
  //     return existingCatalog == null;
  //   }
}
