import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_app/database/library_database.dart';
import 'package:library_app/models/category_with_details.dart';
import 'package:library_app/models/score_with_details.dart';
import 'package:library_app/models/sheet_data.dart';
import 'package:library_app/models/status.dart';
import 'package:library_app/providers/categories_provider.dart';
import 'package:library_app/providers/scores_provider.dart';
import 'package:library_app/screens/view_score/show_dialog.dart';
import 'package:library_app/shared/global_snackbar.dart';
import 'package:library_app/utils/exceptions.dart';
import 'package:library_app/utils/google_sheet_importer.dart';

Future<void> _addScoreToSheet({
  required ScoreWithDetails score,
  required UserSessionData? session,
  required WidgetRef ref,
  String? oldCatNum,
}) async {
  final scoreToSheet = SheetData(score: score);
  final helper = await GoogleSheetHelper.fromRef(ref);
  await helper.insertOrUpdate(rowData: scoreToSheet, oldCatNum: oldCatNum);
}

Future<void> _handleScoreUploadAndNotify({
  required WidgetRef ref,
  required ScoreWithDetails newScore,
  required UserSessionData session,
  required String itemUpdated,
  String? oldCatNum,
}) async {
  String message;
  if (itemUpdated == 'catalog_number') {
    message = "Catalog number updated successfully!";
  } else {
    message = "$itemUpdated updated successfully!";
  }
  bool failed = false;

  try {
    await _addScoreToSheet(
      score: newScore,
      session: session,
      oldCatNum: oldCatNum,
      ref: ref,
    );
  } on AddToSheetException catch (e) {
    message = "Failed to update Sheet: ${e.message}";
    failed = true;
    await ref.read(scoresNotifierProvider.notifier).removeScore(newScore.score);
  }

  GlobalSnackbar.show(
    message: message,
    isError: failed,
    duration: failed ? Duration(seconds: 6) : Duration(seconds: 3),
    onRetry: () async {
      try {
        await ref
            .read(scoresNotifierProvider.notifier)
            .addScoreFromObject(newScore);
        await _addScoreToSheet(score: newScore, session: session, ref: ref);
        GlobalSnackbar.show(
          message: "Retry successful!",
          isError: false,
          onRetry: () {},
        );
      } catch (e) {
        GlobalSnackbar.show(
          message: "Retry failed: ${e.toString()}",
          isError: true,
          duration: const Duration(seconds: 6),
          onRetry: () {
            _handleScoreUploadAndNotify(
              ref: ref,
              newScore: newScore,
              session: session,
              itemUpdated: itemUpdated,
            );
          },
        );
      }
    },
  );
}

void _handleSubmit({
  required String item,
  required ScoreWithDetails score,
  required UserSessionData? session,
  required dynamic newValue,
  required WidgetRef ref,
  String? oldCatNum,
}) async {
  // final scoreChangeTime = score.score.changeTime;
  // if (scoreChangeTime.isBefore(_scoreRefreshTime)) {
  String column = (item == "Category") ? "catalog_number" : item.toLowerCase();
  final newScore = await ref
      .read(scoresNotifierProvider.notifier)
      .updateScore(column, newValue, score.score.id);
  if (newScore == null) {
    throw Exception("Could not update database");
  }
  // _scoreRefreshTime = DateTime.now();
  Future(
    () => _handleScoreUploadAndNotify(
      ref: ref,
      newScore: newScore,
      session: session!,
      itemUpdated: item,
      oldCatNum: oldCatNum,
    ),
  );
  // } else {
  //   Navigator.of(
  //     context,
  //   ).pushReplacement(MaterialPageRoute(builder: (_) => FixErrorsPage()));
  // }
}

void titleSubmit({
  required ScoreWithDetails score,
  required UserSessionData? session,
  required WidgetRef ref,
  required BuildContext context,
  required TextEditingController controller,
}) {
  controller.text = score.score.title;
  DialogHelper.showTextEditDialog(
    context: context,
    name: "Title",
    controller: controller,
    validator: () => controller.text.isEmpty ? "Title cannot be empty" : null,
    handleSubmit: () async {
      _handleSubmit(
        item: "Title",
        score: score,
        session: session,
        newValue: controller.text,
        ref: ref,
      );
    },
  );
}

void composerSubmit({
  required ScoreWithDetails score,
  required UserSessionData? session,
  required TextEditingController controller,
  required BuildContext context,
  required WidgetRef ref,
}) {
  controller.text = (score.composer != null) ? score.composer!.name : "";
  DialogHelper.showTextEditDialog(
    context: context,
    controller: controller,
    name: "Composer",
    validator:
        () => controller.text.isEmpty ? "Composer cannot be empty" : null,
    handleSubmit: () async {
      ComposerData? composer = await ref
          .read(scoresNotifierProvider.notifier)
          .getComposer(controller.text);
      composer ??= await ref
          .read(scoresNotifierProvider.notifier)
          .addComposer(controller.text);
      _handleSubmit(
        item: "Composer",
        score: score,
        session: session,
        newValue: composer.id,
        ref: ref,
      );
    },
  );
}

void arrangerSubmit({
  required ScoreWithDetails score,
  required UserSessionData? session,
  required WidgetRef ref,
  required TextEditingController controller,
  required BuildContext context,
}) {
  controller.text = score.score.arranger;
  DialogHelper.showTextEditDialog(
    context: context,
    controller: controller,
    name: "Arranger",
    validator: () => null,
    handleSubmit: () async {
      _handleSubmit(
        item: "Arranger",
        score: score,
        session: session,
        newValue: controller.text,
        ref: ref,
      );
    },
  );
}

void categorySubmit({
  required ScoreWithDetails score,
  required List<CategoryWithDetails> categories,
  required UserSessionData? session,
  required BuildContext context,
  required WidgetRef ref,
  required CategoryData? selectedCategory,
  required Set<SubcategoryData> selectedSubcategories,
}) {
  DialogHelper.showCatalogDialog(
    context: context,
    selectedCategory: score.category,
    categories: categories,
    onCategorySelect: (category) => selectedCategory = category,
    name: "Category",
    handleSubmit: () async {
      if (score.category != selectedCategory) {
        selectedSubcategories.clear();
        final oldCatalogNumber = score.score.catalogNumber;
        await ref
            .read(scoresNotifierProvider.notifier)
            .updateScore('category', selectedCategory!.id, score.score.id);
        final newCatalogNum = await ref
            .read(scoresNotifierProvider.notifier)
            .getNewCatalogNumber(
              selectedCategory!.id,
              selectedCategory!.identifier,
            );
        _handleSubmit(
          item: 'Category',
          score: score,
          session: session,
          newValue: newCatalogNum,
          oldCatNum: oldCatalogNumber,
          ref: ref,
        );
      }
    },
  );
}

void subCategorySubmit({
  required ScoreWithDetails score,
  required UserSessionData? session,
  required TextEditingController controller,
  required WidgetRef ref,
  required CategoryData? selectedCategory,
  required Set<SubcategoryData> selectedSubcategories,
  required BuildContext context,
}) async {
  controller.clear();
  selectedCategory = score.category;
  selectedSubcategories = {...score.subcategories ?? {}};
  final categorySubcategories = await ref
      .read(categoriesNotifierProvider.notifier)
      .getSubcategoriesByCategory(selectedCategory!.id);
  if (!context.mounted) return;
  DialogHelper.showSubcategoriesDialog(
    context: context,
    selectedCategory: selectedCategory,
    categorySubcategories: categorySubcategories,
    selectedSubcategories: {...selectedSubcategories},
    onAddSubcategory: (newName) async {
      final newSubcategory = SubcategoriesCompanion(
        categoryId: Value(selectedCategory!.id),
        name: Value(newName),
      );

      final updatedCategory = await ref
          .read(categoriesNotifierProvider.notifier)
          .addSubcategory(newSubcategory);

      return updatedCategory.subcategories?.lastWhere(
        (sub) => sub.name == newName,
      );
    },

    controller: controller,
    name: "Subcategories",
    handleSubmit: (updatedSelection) {
      selectedSubcategories = updatedSelection;
      _handleSubmit(
        item: "Subcategories",
        score: score,
        session: session,
        newValue: {...selectedSubcategories},
        ref: ref,
      );
    },
  );
}

void catalogNumberSubmit({
  required ScoreWithDetails score,
  required UserSessionData? session,
  required TextEditingController controller,
  required BuildContext context,
  required Future<String?> catalogValidator,
  required WidgetRef ref,
}) async {
  controller.text = score.score.catalogNumber;
  DialogHelper.showCatalogEditDialog(
    context: context,
    name: "Catalog Number",
    controller: controller,
    validator: () => catalogValidator,
    handleSubmit: () {
      final oldCatNum = score.score.catalogNumber;
      ref
          .read(scoresNotifierProvider.notifier)
          .updateScore('catalog_number', controller.text, score.score.id);
      _handleSubmit(
        item: 'catalog_number',
        score: score,
        session: session,
        newValue: controller.text,
        oldCatNum: oldCatNum,
        ref: ref,
      );
    },
  );
}

void statusSubmit({
  required ScoreWithDetails score,
  required UserSessionData? session,
  required BuildContext context,
  required Status? selectedStatus,
  required WidgetRef ref,
}) {
  DialogHelper.showStatusDialog(
    context: context,
    selectedStatus: score.status,
    onStatusSelect: (status) => selectedStatus = status,
    name: "Status",
    handleSubmit: () {
      if (selectedStatus == null) return;
      _handleSubmit(
        item: 'Status',
        score: score,
        session: session,
        newValue: selectedStatus!.title,
        ref: ref,
      );
    },
  );
}

void notesSubmit({
  required ScoreWithDetails score,
  required UserSessionData? session,
  required TextEditingController controller,
  required BuildContext context,
  required WidgetRef ref,
}) {
  controller.text = score.score.notes;
  DialogHelper.showTextEditDialog(
    context: context,
    controller: controller,
    name: "Notes",
    validator: () => null,
    handleSubmit: () {
      _handleSubmit(
        item: "Notes",
        score: score,
        session: session,
        newValue: controller.text,
        ref: ref,
      );
    },
  );
}

void resetOnClick({
  required WidgetRef ref,
  required ScoreWithDetails score,
  required UserSessionData? session,
  required ScoreWithDetails resetScore,
}) async {
  String message = 'Score updated successfully!';
  bool failed = false;

  final oldCatNum = score.score.catalogNumber;
  final newScore = await ref
      .read(scoresNotifierProvider.notifier)
      .updateScoreFromObject(resetScore.score, resetScore.subcategories);
  try {
    await _addScoreToSheet(
      score: newScore,
      session: session,
      oldCatNum: oldCatNum,
      ref: ref,
    );
  } on AddToSheetException catch (e) {
    message = "Failed to reset Sheet: ${e.message}";
    failed = true;
    await ref
        .read(scoresNotifierProvider.notifier)
        .updateScoreFromObject(score.score, score.subcategories);
  }
  if (failed) {
    GlobalSnackbar.show(
      message: message,
      isError: failed,
      duration: Duration(seconds: 6),
      onRetry: () async {
        try {
          await ref
              .read(scoresNotifierProvider.notifier)
              .updateScoreFromObject(newScore.score, newScore.subcategories);
          await _addScoreToSheet(
            score: newScore,
            session: session,
            oldCatNum: oldCatNum,
            ref: ref,
          );
        } catch (e) {
          GlobalSnackbar.show(
            message: "Retry failed: ${e.toString()}",
            isError: true,
            duration: const Duration(seconds: 6),
            onRetry: () {
              resetOnClick(
                ref: ref,
                score: newScore,
                session: session,
                resetScore: resetScore,
              );
            },
          );
        }
      },
    );
  }
}
