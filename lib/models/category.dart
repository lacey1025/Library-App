// class Category {
//   final String _name;
//   final Set<String> _subcategories;
//   final String _identifier;
//   int _counter = 1;
//   static Category defaultCategory = Category(
//     identifier: "",
//     name: "None",
//     subcategories: {},
//   );

//   Category({
//     required String identifier,
//     required String name,
//     Set<String>? subcategories,
//   }) : _identifier = identifier.toUpperCase(),
//        _name = name,
//        _subcategories = subcategories ?? {};

//   Set<String> get subcategories => _subcategories;
//   String get name => _name;
//   String get identifier => _identifier;

//   int get counter => _counter;
//   set counter(int value) {
//     if (value > _counter) {
//       _counter = value;
//     }
//   }

//   Category copyWith({
//     String? name,
//     Set<String>? subcategories,
//     String? identifier,
//   }) {
//     var newCategory = Category(
//       name: name ?? this.name,
//       subcategories: subcategories ?? {...this.subcategories},
//       identifier: identifier ?? this.identifier,
//     );
//     newCategory._counter = _counter;
//     return newCategory;
//   }

//   void addSubcategory(dynamic subcategory) {
//     if (subcategory is String) {
//       _subcategories.add(subcategory.toLowerCase());
//     } else if (subcategory is Set<String>) {
//       _subcategories.addAll(subcategory.map((s) => s.toLowerCase()));
//     } else {
//       throw ArgumentError('Expected a String or Set<String>');
//     }
//   }

//   void removeSubcategory(String subcategory) {
//     _subcategories.remove(subcategory.toLowerCase());
//   }

//   String getNewId() {
//     String id = '$_identifier ${_counter.toString().padLeft(4, '0')}';
//     counter++;
//     return id;
//   }
// }
