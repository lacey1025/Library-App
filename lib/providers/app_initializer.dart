import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_app/database/library_database.dart';
import 'package:library_app/providers/categories_provider.dart';

final appInitializerProvider = FutureProvider<void>((ref) async {
  final categoryNotifier = ref.read(categoriesNotifierProvider.notifier);
  final state = await ref.watch(categoriesNotifierProvider.future);

  if (state.isEmpty) {
    await categoryNotifier.addCategory(
      CategoriesCompanion(name: Value("Concert Band"), identifier: Value("C")),
    );
    await categoryNotifier.addCategory(
      CategoriesCompanion(name: Value("Swing Band"), identifier: Value("S")),
    );
    await categoryNotifier.addCategory(
      CategoriesCompanion(name: Value("Marching Band"), identifier: Value("M")),
    );
    await categoryNotifier.addCategory(
      CategoriesCompanion(
        name: Value("Brass Ensemble"),
        identifier: Value("BR"),
      ),
    );
  }
});
