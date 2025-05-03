import 'package:library_app/database/library_database.dart';

class CategoryWithDetails {
  final CategoryData category;
  final Set<SubcategoryData>? subcategories;

  CategoryWithDetails({required this.category, this.subcategories});
}
