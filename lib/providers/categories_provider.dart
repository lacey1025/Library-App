import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_app/database/library_database.dart';
import 'package:library_app/database/category_dao.dart';
import 'package:library_app/models/category_with_details.dart';
import 'package:library_app/providers/database_provider.dart';

class CategoriesProvider extends StreamNotifier<List<CategoryWithDetails>> {
  late final CategoryDao _categoryDao;

  @override
  Stream<List<CategoryWithDetails>> build() {
    final db = ref.watch(databaseProvider);
    _categoryDao = CategoryDao(db);
    return _categoryDao.watchAllCategories();
  }

  Future<void> updateCategory(CategoriesCompanion category) async {
    state = const AsyncLoading();
    await _categoryDao.insertOrUpdateCategory(category);
    state = AsyncData(await _categoryDao.getAllCategories());
  }

  Future<CategoryWithDetails> addCategory(CategoriesCompanion category) async {
    state = const AsyncLoading();
    final newId = await _categoryDao.insertOrUpdateCategory(category);
    final newCategory = await _categoryDao.getCategoryWithDetailsById(newId);
    state = AsyncData(await _categoryDao.getAllCategories());
    return newCategory;
  }

  Future<void> deleteCategory(String name) async {
    state = const AsyncLoading();
    await _categoryDao.deleteCategory(name);
    state = AsyncData(await _categoryDao.getAllCategories());
  }

  Future<CategoryWithDetails> addSubcategory(
    SubcategoriesCompanion subcategory,
  ) async {
    await _categoryDao.addSubcategory(subcategory);
    final updated = await _categoryDao.getCategoryWithDetailsById(
      subcategory.categoryId.value,
    );

    final currentList = state.valueOrNull ?? [];
    final updatedList = [
      for (final cat in currentList)
        if (cat.category.id == updated.category.id) updated else cat,
    ];

    state = AsyncData(updatedList);
    return updated;
  }

  Future<List<SubcategoryData>> getSubcategoriesByCategory(
    int categoryId,
  ) async {
    return await _categoryDao.getSubcategoriesByCategory(categoryId);
  }
}

final categoriesNotifierProvider =
    StreamNotifierProvider<CategoriesProvider, List<CategoryWithDetails>>(
      CategoriesProvider.new,
    );
