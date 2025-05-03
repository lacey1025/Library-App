// import 'package:library_app/models/category.dart';
// import 'package:library_app/models/status.dart';

// class Score {
//   final String id;
//   final String title;
//   final String composer;
//   final String arranger;
//   String _catalogNumber;
//   final String notes;
//   final Category category;
//   final Set<String>? subcategories;
//   final Status status;

//   Score({
//     required this.id,
//     required this.title,
//     required this.composer,
//     required this.category,
//     required this.status,
//     String? catalogNumber,
//     Set<String>? subcategories,
//     this.arranger = "",
//     this.notes = "",
//   }) : _catalogNumber =
//            (catalogNumber == null || catalogNumber.isEmpty)
//                ? category.getNewId()
//                : catalogNumber,
//        subcategories = subcategories ?? {};

//   String get catalogNumber => _catalogNumber;

//   void setCatalogNumber(String newNumber) {
//     final splitNumber = newNumber.split(' ');
//     splitNumber[0] = splitNumber[0].trim().toUpperCase();
//     _catalogNumber = splitNumber.join(' ');
//   }

//   Score copyWith({
//     String? id,
//     String? title,
//     String? composer,
//     String? arranger,
//     String? catalogNumber,
//     String? notes,
//     Category? category,
//     Set<String>? subcategories,
//     Status? status,
//   }) {
//     return Score(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       composer: composer ?? this.composer,
//       arranger: arranger ?? this.arranger,
//       catalogNumber: catalogNumber ?? this.catalogNumber,
//       notes: notes ?? this.notes,
//       category: category ?? this.category,
//       subcategories: subcategories ?? this.subcategories,
//       status: status ?? this.status,
//     );
//   }

//   @override
//   String toString() {
//     return ("Title: $title, Composer: $composer, Category: ${category.name} Status: ${status.title}, $catalogNumber Subcategories: $subcategories Arranger: $arranger Notes: $notes");
//   }

//   Score.clone(Score other)
//     : title = other.title,
//       id = other.id,
//       composer = other.composer,
//       arranger = other.arranger,
//       _catalogNumber = other.catalogNumber,
//       notes = other.notes,
//       category = other.category,
//       status = other.status,
//       subcategories = Set.from(other.subcategories!);

//   void addSubcategoriesFromString(String words) {
//     final cats = words.split('/').map((s) => s.toLowerCase().trim()).toSet();
//     final difference = cats.difference(category.subcategories);
//     if (difference.isNotEmpty) {
//       category.addSubcategory(difference);
//     }
//     subcategories!.addAll(cats);
//   }

//   String subcategoriesToString() {
//     return subcategories!.join('/');
//   }

//   static String? catalogValidiator(value, Category category) {
//     if (value == null || value.isEmpty) {
//       return null;
//     }
//     final regex = RegExp(r'^[A-Za-z]+ \d{1,4}$');
//     if (!regex.hasMatch(value)) {
//       return 'Invalid format. Use: "Text 1234" (letters + space + up to 4 digits)';
//     }
//     final splitNumber = value.split(' ');
//     if (splitNumber[0].trim().toUpperCase() != category.identifier) {
//       return '${category.name} numbers must start with ${category.identifier}';
//     }
//     return null;
//   }
// }
