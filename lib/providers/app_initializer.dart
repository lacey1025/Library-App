import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:library_app/database/library_database.dart';
import 'package:library_app/models/app_start_info.dart';
import 'package:library_app/providers/categories_provider.dart';
import 'package:library_app/providers/session_provider.dart';

final appInitializerProvider = FutureProvider<AppStartInfo>((ref) async {
  final categoryNotifier = ref.read(categoriesNotifierProvider.notifier);
  final categories = ref.read(categoriesNotifierProvider);
  if (categories is AsyncData && categories.value!.isEmpty) {
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

  final session = await ref.read(sessionProvider.future);
  final googleSignIn = ref.read(googleSignInProvider);
  final account = await googleSignIn.signInSilently();
  return AppStartInfo(session: session, googleAccount: account);
});

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/drive.file',
      'https://www.googleapis.com/auth/spreadsheets',
    ],
  );
});
