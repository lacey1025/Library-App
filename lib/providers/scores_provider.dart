import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_app/database/library_database.dart';
import 'package:library_app/models/score_with_details.dart';
import 'package:library_app/providers/database_provider.dart';
import 'package:library_app/database/scores_dao.dart';

class ScoresProvider extends AsyncNotifier<List<ScoreWithDetails>> {
  late final ScoresDao _scoresDao;

  @override
  Future<List<ScoreWithDetails>> build() async {
    final db = ref.watch(databaseProvider);
    _scoresDao = ScoresDao(db);
    return await _scoresDao.getAllScores();
  }

  Future<ScoreWithDetails> addScore(
    ScoresCompanion score,
    Set<SubcategoryData>? subcategories,
  ) async {
    state = AsyncData(state.value ?? []);
    final newScore = await _scoresDao.insertOrUpdateScore(
      null,
      score,
      subcategories,
    );
    final current = state.valueOrNull ?? [];
    state = AsyncData([...current, newScore]);
    return newScore;
  }

  Future<void> addScoreFromObject(ScoreWithDetails score) async {
    state = AsyncData(state.value ?? []);
    ScoresCompanion companion = ScoresCompanion(
      id: Value(score.score.id),
      title: Value(score.score.title),
      composerId: Value(score.score.composerId),
      arranger: Value(score.score.arranger),
      catalogNumber: Value(score.score.catalogNumber),
      notes: Value(score.score.notes),
      categoryId: Value(score.score.categoryId),
      status: Value(score.score.status),
      link: Value(score.score.link),
      changeTime: Value(DateTime.now()),
    );
    final newScore = await _scoresDao.insertOrUpdateScore(
      null,
      companion,
      score.subcategories,
    );
    final current = state.valueOrNull ?? [];
    state = AsyncData([...current, newScore]);
  }

  Future<void> updateScoreFromObject(
    ScoreData score,
    Set<SubcategoryData>? subcategories,
  ) async {
    state = AsyncData(state.value ?? []);
    ScoresCompanion companion = ScoresCompanion(
      id: Value(score.id),
      title: Value(score.title),
      composerId: Value(score.composerId),
      arranger: Value(score.arranger),
      catalogNumber: Value(score.catalogNumber),
      notes: Value(score.notes),
      categoryId: Value(score.categoryId),
      status: Value(score.status),
      link: Value(score.link),
      changeTime: Value(DateTime.now()),
    );
    final newScore = await _scoresDao.insertOrUpdateScore(
      score.id,
      companion,
      subcategories,
    );
    final current = state.valueOrNull ?? [];
    state = AsyncData([
      for (final score in current)
        if (score.score.id == newScore.score.id) newScore else score,
    ]);
  }

  Future<void> updateScore(String item, dynamic value, int id) async {
    state = AsyncData(state.value ?? []);
    try {
      ScoresCompanion companion = ScoresCompanion(
        title: (item == 'title') ? Value(value) : Value.absent(),
        composerId: (item == 'composer') ? Value(value) : Value.absent(),
        arranger: (item == 'arranger') ? Value(value) : Value.absent(),
        catalogNumber:
            (item == 'catalog_number') ? Value(value) : Value.absent(),
        notes: (item == 'notes') ? Value(value) : Value.absent(),
        categoryId: (item == 'category') ? Value(value) : Value.absent(),
        status: (item == 'status') ? Value(value) : Value.absent(),
        link: (item == 'link') ? Value(value) : Value.absent(),
        changeTime: Value(DateTime.now()),
      );

      Set<SubcategoryData>? subcategories;
      if (item == 'subcategories') {
        subcategories = value;
      } else if (item == 'category') {
        subcategories = {};
      }

      final newScore = await _scoresDao.insertOrUpdateScore(
        id,
        companion,
        subcategories,
      );
      final current = state.valueOrNull ?? [];
      state = AsyncData([
        for (final score in current)
          if (score.score.id == newScore.score.id) newScore else score,
      ]);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> removeScore(ScoreData score) async {
    state = const AsyncLoading();
    await _scoresDao.deleteScore(score.id);
    state = AsyncData(await _scoresDao.getAllScores());
  }

  Future<String> getNewCatalogNumber(int categoryId, String identifier) async {
    return await _scoresDao.getNewCatalogNumber(categoryId, identifier);
  }

  Future<bool> checkCatalogNumber(String catalogNumber, int categoryId) async {
    return await _scoresDao.checkCatalogNumber(catalogNumber, categoryId);
  }

  Future<ComposerData?> getComposer(String name) async {
    return await _scoresDao.getComposerByName(name);
  }

  Future<ComposerData> addComposer(String name) async {
    return await _scoresDao.addComposer(name);
  }
}

final scoresNotifierProvider =
    AsyncNotifierProvider<ScoresProvider, List<ScoreWithDetails>>(() {
      return ScoresProvider();
    });

final scoreByIdProvider = Provider.family<AsyncValue<ScoreWithDetails>, int>((
  ref,
  id,
) {
  final scoresAsync = ref.watch(scoresNotifierProvider);
  return scoresAsync.whenData(
    (scores) => scores.firstWhere((s) => s.score.id == id),
  );
});
