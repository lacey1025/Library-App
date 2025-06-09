import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_app/database/category_dao.dart';
import 'package:library_app/database/score_subcategories_dao.dart';
import 'package:library_app/database/scores_dao.dart';
import 'package:library_app/database/library_database.dart';
import 'package:library_app/database/session_dao.dart';

final databaseProvider = Provider<LibraryDatabase>((ref) {
  final database = LibraryDatabase();
  ref.onDispose(() {
    database.close();
  });
  return database;
});

final categoryDaoProvider = Provider<CategoryDao?>((ref) {
  final db = ref.watch(databaseProvider);
  return CategoryDao(db);
});

final scoresDaoProvider = Provider<ScoresDao?>((ref) {
  final db = ref.watch(databaseProvider);
  return ScoresDao(db);
});

final scoreSubcategoriesDaoProvider = Provider<ScoreSubcategoriesDao?>((ref) {
  final db = ref.watch(databaseProvider);
  return db.scoreSubcategoriesDao;
});

final scoreSubcategoriesProvider =
    FutureProvider.family<List<SubcategoryData>, int>((ref, scoreId) async {
      final dao = ref.watch(scoreSubcategoriesDaoProvider);
      if (dao == null) return [];
      return await dao.getSubcategoriesForScore(scoreId);
    });

final sessionDaoProvider = Provider<SessionDao?>((ref) {
  final db = ref.watch(databaseProvider);
  return db.sessionDao;
});
