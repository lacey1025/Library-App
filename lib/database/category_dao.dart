import 'package:drift/drift.dart';
import 'package:library_app/database/library_database.dart';
import 'package:library_app/models/category_with_details.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [Categories, Subcategories])
class CategoryDao extends DatabaseAccessor<LibraryDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(super.db);

  Future<List<CategoryWithDetails>> getAllCategories() async {
    final query = select(categories).join([
      leftOuterJoin(
        subcategories,
        subcategories.categoryId.equalsExp(categories.id),
      ),
    ]);
    final rows = await query.get();
    final Map<int, CategoryWithDetails> categoryMap = {};

    for (final row in rows) {
      final category = row.readTable(categories);
      final subcategory = row.readTableOrNull(subcategories);
      categoryMap.putIfAbsent(
        category.id,
        () => CategoryWithDetails(category: category, subcategories: {}),
      );
      if (subcategory != null) {
        categoryMap[category.id]!.subcategories!.add(subcategory);
      }
    }
    return categoryMap.values.toList();
  }

  Future<List<SubcategoryData>> getAllSubCategories() async {
    return select(subcategories).get();
  }

  Future<List<CategoryData>> getAllRawCategories() async {
    return select(categories).get();
  }

  Future<CategoryData?> getCategoryByName(String name) async {
    return (select(categories)
      ..where((c) => c.name.equals(name))).getSingleOrNull();
  }

  Future<int> insertOrUpdateCategory(CategoriesCompanion category) async {
    return await into(categories).insertOnConflictUpdate(category);
  }

  Future<List<CategoryData>> bulkInsertCategories(
    Map<String, String> nameToIdentifier,
  ) async {
    if (nameToIdentifier.isEmpty) return [];

    await batch((batch) {
      batch.insertAll(
        categories,
        nameToIdentifier.entries
            .map(
              (e) => CategoriesCompanion(
                name: Value(e.key),
                identifier: Value(e.value),
              ),
            )
            .toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
    return await (select(categories)
      ..where((c) => c.name.isIn(nameToIdentifier.keys.toList()))).get();
  }

  Future<void> deleteCategory(String name) async {
    await (delete(categories)..where((c) => c.name.equals(name))).go();
  }

  Future<SubcategoryData> addSubcategory(
    SubcategoriesCompanion subcategory,
  ) async {
    return await into(subcategories).insertReturning(subcategory);
  }

  Future<List<SubcategoryData>> bulkInserSubcategories(
    List<SubcategoriesCompanion> companions,
  ) async {
    if (companions.isEmpty) return [];
    await batch((batch) {
      batch.insertAll(
        subcategories,
        companions,
        mode: InsertMode.insertOrIgnore,
      );
    });

    final names = companions.map((c) => c.name.value).toSet().toList();
    return await (select(subcategories)
      ..where((s) => s.name.isIn(names))).get();
  }

  Future<List<SubcategoryData>> getSubcategoriesByCategory(
    int categoryId,
  ) async {
    return await (select(subcategories)
      ..where((s) => s.categoryId.equals(categoryId))).get();
  }

  Future<CategoryWithDetails> getCategoryWithDetailsById(int categoryId) async {
    final category =
        await (select(categories)
          ..where((tbl) => tbl.id.equals(categoryId))).getSingle();
    final subcategoriesList =
        await (select(subcategories)
          ..where((tbl) => tbl.categoryId.equals(categoryId))).get();

    return CategoryWithDetails(
      category: category,
      subcategories: subcategoriesList.toSet(),
    );
  }

  Future<CategoryData?> getCategoryDataById(int categoryId) {
    return (select(categories)
      ..where((c) => c.id.equals(categoryId))).getSingleOrNull();
  }

  // String getNewId() {
  //   String id = '$_identifier ${_counter.toString().padLeft(4, '0')}';
  //   counter++;
  //   return id;
  // }
}
