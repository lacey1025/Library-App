import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_app/database/library_database.dart';
import 'package:library_app/models/category_with_details.dart';
import 'package:library_app/models/score_with_details.dart';
import 'package:library_app/models/sheet_data.dart';
import 'package:library_app/models/status.dart';
import 'package:library_app/providers/app_initializer.dart';
import 'package:library_app/providers/categories_provider.dart';
import 'package:library_app/providers/scores_provider.dart';
import 'package:library_app/providers/session_provider.dart';
import 'package:library_app/screens/login/login_screen.dart';
import 'package:library_app/screens/view_score/bottom_button_section.dart';
import 'package:library_app/screens/view_score/score_field.dart';
import 'package:library_app/screens/view_score/show_dialog.dart';
import 'package:library_app/screens/view_score/view_edit_field.dart';
import 'package:library_app/shared/app_drawer.dart';
import 'package:library_app/shared/appbar.dart';
import 'package:library_app/shared/global_snackbar.dart';
import 'package:library_app/utils/drive_helper.dart';
import 'package:library_app/utils/exceptions.dart';
import 'package:library_app/utils/google_sheet_importer.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewScore extends ConsumerStatefulWidget {
  const ViewScore(this.scoreId, {super.key});

  final int scoreId;

  @override
  ConsumerState<ViewScore> createState() => _ViewScoreState();
}

class _ViewScoreState extends ConsumerState<ViewScore> {
  final TextEditingController _controller = TextEditingController();
  CategoryData? _selectedCategory;
  Status? _selectedStatus;
  Set<SubcategoryData> _selectedSubcategories = {};
  late ScoreWithDetails resetScore;
  String edit = "Edit";
  bool _initialized = false;
  late DateTime _scoreRefreshTime;
  bool _uploading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _addScoreToSheet({
    required ScoresProvider scoresNotifier,
    required GoogleSheetHelper sheetHelper,
    required ScoreWithDetails score,
    required UserSessionData? session,
    String? oldCatNum,
  }) async {
    final scoreToSheet = SheetData(score: score);
    await sheetHelper.insertOrUpdate(
      rowData: scoreToSheet,
      oldCatNum: oldCatNum,
    );
  }

  Future<void> _handleScoreUploadAndNotify({
    required ScoresProvider scoreNotifier,
    required GoogleSheetHelper sheetHelper,
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
        scoresNotifier: scoreNotifier,
        sheetHelper: sheetHelper,
        score: newScore,
        session: session,
        oldCatNum: oldCatNum,
      );
    } on AddToSheetException catch (e) {
      message = "Failed to update Sheet: ${e.message}";
      failed = true;
      await scoreNotifier.removeScore(newScore.score);
    }
    GlobalSnackbar.show(
      message: message,
      isError: failed,
      duration: failed ? Duration(seconds: 6) : Duration(seconds: 3),
      onRetry: () async {
        try {
          await scoreNotifier.addScoreFromObject(newScore);
          await _addScoreToSheet(
            scoresNotifier: scoreNotifier,
            sheetHelper: sheetHelper,
            score: newScore,
            session: session,
          );
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
                scoreNotifier: scoreNotifier,
                sheetHelper: sheetHelper,
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

  Future<void> _handleSubmit({
    required String item,
    required ScoreWithDetails score,
    required UserSessionData? session,
    required dynamic newValue,
    String? oldCatNum,
  }) async {
    final scoreNotifier = ref.read(scoresNotifierProvider.notifier);
    final sheetHelper = await GoogleSheetHelper.fromRef(ref);
    // cache the change time on import, fetch again, compare the times, if current > cached show conflict warning
    // final scoreChangeTime = score.score.changeTime;
    // if (scoreChangeTime.isBefore(_scoreRefreshTime)) {
    String column =
        (item == "Category") ? "catalog_number" : item.toLowerCase();
    final newScore = await scoreNotifier.updateScore(
      column,
      newValue,
      score.score.id,
    );
    if (newScore == null) {
      throw Exception("Could not update database");
    }
    _scoreRefreshTime = DateTime.now();
    Future(
      () => _handleScoreUploadAndNotify(
        sheetHelper: sheetHelper,
        scoreNotifier: scoreNotifier,
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

  void _titleSubmit(ScoreWithDetails score, UserSessionData? session) {
    _controller.text = score.score.title;
    DialogHelper.showTextEditDialog(
      context: context,
      name: "Title",
      controller: _controller,
      validator:
          () => _controller.text.isEmpty ? "Title cannot be empty" : null,
      handleSubmit: () async {
        _handleSubmit(
          item: "Title",
          score: score,
          session: session,
          newValue: _controller.text,
        );
      },
    );
  }

  void _composerSubmit(ScoreWithDetails score, UserSessionData? session) {
    _controller.text = (score.composer != null) ? score.composer!.name : "";
    DialogHelper.showTextEditDialog(
      context: context,
      controller: _controller,
      name: "Composer",
      validator:
          () => _controller.text.isEmpty ? "Composer cannot be empty" : null,
      handleSubmit: () async {
        ComposerData? composer = await ref
            .read(scoresNotifierProvider.notifier)
            .getComposer(_controller.text);
        composer ??= await ref
            .read(scoresNotifierProvider.notifier)
            .addComposer(_controller.text);
        _handleSubmit(
          item: "Composer",
          score: score,
          session: session,
          newValue: composer.id,
        );
      },
    );
  }

  void _arrangerSubmit(ScoreWithDetails score, UserSessionData? session) {
    _controller.text = score.score.arranger;
    DialogHelper.showTextEditDialog(
      context: context,
      controller: _controller,
      name: "Arranger",
      validator: () => null,
      handleSubmit: () async {
        _handleSubmit(
          item: "Arranger",
          score: score,
          session: session,
          newValue: _controller.text,
        );
      },
    );
  }

  Future<bool> _isValidLink(String link) async {
    final uri = Uri.tryParse(link);
    return uri != null && await canLaunchUrl(uri);
  }

  void _linkSubmit(ScoreWithDetails score, UserSessionData? session) {
    _controller.text = score.score.link == null ? '' : score.score.link!;
    DialogHelper.showTextEditDialog(
      context: context,
      controller: _controller,
      name: "Link",
      validator: () => null,
      handleSubmit: () async {
        _handleSubmit(
          item: "Link",
          score: score,
          session: session,
          newValue: _controller.text,
        );
      },
    );
  }

  void _categorySubmit(
    ScoreWithDetails score,
    List<CategoryWithDetails> categories,
    UserSessionData? session,
  ) {
    DialogHelper.showCatalogDialog(
      context: context,
      selectedCategory: _selectedCategory,
      categories: categories,
      onCategorySelect: (category) => _selectedCategory = category,
      name: "Category",
      handleSubmit: () async {
        if (score.category != _selectedCategory) {
          _selectedSubcategories.clear();
          final oldCatalogNumber = score.score.catalogNumber;
          final oldCategoryName = score.category!.name;
          await ref
              .read(scoresNotifierProvider.notifier)
              .updateScore('category', _selectedCategory!.id, score.score.id);
          final newCatalogNum = await ref
              .read(scoresNotifierProvider.notifier)
              .getNewCatalogNumber(
                _selectedCategory!.id,
                _selectedCategory!.identifier,
              );
          _handleSubmit(
            item: 'Category',
            score: score,
            session: session,
            newValue: newCatalogNum,
            oldCatNum: oldCatalogNumber,
          );

          if (score.score.link != null && score.score.link!.isNotEmpty) {
            final account = ref.read(googleSignInProvider);
            DriveHelper.moveFile(
              account: account,
              parentFolderId: session!.driveFolderId!,
              oldFolderName: oldCategoryName,
              newFolderName: _selectedCategory!.name,
              fileAddress: score.score.link!,
            );
          }
        }
      },
    );
  }

  void _subCategorySubmit(
    ScoreWithDetails score,
    UserSessionData? session,
  ) async {
    _controller.clear();
    _selectedCategory = score.category;
    _selectedSubcategories = {...score.subcategories ?? {}};
    final categorySubcategories = await ref
        .read(categoriesNotifierProvider.notifier)
        .getSubcategoriesByCategory(_selectedCategory!.id);
    if (!mounted) return;
    DialogHelper.showSubcategoriesDialog(
      context: context,
      selectedCategory: _selectedCategory!,
      categorySubcategories: categorySubcategories,
      selectedSubcategories: {..._selectedSubcategories},
      onAddSubcategory: (newName) async {
        final newSubcategory = SubcategoriesCompanion(
          categoryId: Value(_selectedCategory!.id),
          name: Value(newName),
        );

        final updatedCategory = await ref
            .read(categoriesNotifierProvider.notifier)
            .addSubcategory(newSubcategory);

        return updatedCategory.subcategories?.lastWhere(
          (sub) => sub.name == newName,
        );
      },

      controller: _controller,
      name: "Subcategories",
      handleSubmit: (updatedSelection) {
        _selectedSubcategories = updatedSelection;
        _handleSubmit(
          item: "Subcategories",
          score: score,
          session: session,
          newValue: {..._selectedSubcategories},
        );
      },
    );
  }

  Future<String?> _catalogValidiator(String? value) async {
    if (_selectedCategory == null) {
      return "Please select a category";
    }
    if (value == null || value.isEmpty) {
      _controller.text = await ref
          .read(scoresNotifierProvider.notifier)
          .getNewCatalogNumber(
            _selectedCategory!.id,
            _selectedCategory!.identifier,
          );
      return null;
    }
    final regex = RegExp(r'^[A-Za-z]+\s?\d{1,4}$');
    if (!regex.hasMatch(value)) {
      return 'Invalid format. Use: "Text1234" \n(letters + up to 4 digits)';
    }
    final valueIdentifier =
        value
            .substring(0, _selectedCategory!.identifier.length)
            .trim()
            .toUpperCase();
    if (valueIdentifier != _selectedCategory!.identifier) {
      return '${_selectedCategory!.name} numbers must start with ${_selectedCategory!.identifier}';
    }
    final numbers = RegExp(r'\d+').firstMatch(value)?.group(0);
    if (numbers != null) {
      _controller.text = valueIdentifier + numbers;
    }
    final isUnique = await ref
        .read(scoresNotifierProvider.notifier)
        .checkCatalogNumber(value, _selectedCategory!.id);
    if (!isUnique) {
      return 'Catalog number has already been used';
    }
    return null;
  }

  void _catalogNumberSubmit(
    ScoreWithDetails score,
    UserSessionData? session,
  ) async {
    _controller.text = score.score.catalogNumber;
    DialogHelper.showCatalogEditDialog(
      context: context,
      name: "Catalog Number",
      controller: _controller,
      validator: () => _catalogValidiator(_controller.text),
      handleSubmit: () {
        final oldCatNum = score.score.catalogNumber;
        ref
            .read(scoresNotifierProvider.notifier)
            .updateScore('catalog_number', _controller.text, score.score.id);
        _handleSubmit(
          item: 'catalog_number',
          score: score,
          session: session,
          newValue: _controller.text,
          oldCatNum: oldCatNum,
        );
      },
    );
  }

  void _statusSubmit(ScoreWithDetails score, UserSessionData? session) {
    DialogHelper.showStatusDialog(
      context: context,
      selectedStatus: _selectedStatus,
      onStatusSelect: (status) => _selectedStatus = status,
      name: "Status",
      handleSubmit: () {
        if (_selectedStatus == null) return;
        _handleSubmit(
          item: 'Status',
          score: score,
          session: session,
          newValue: _selectedStatus!.title,
        );
      },
    );
  }

  void _notesSubmit(ScoreWithDetails score, UserSessionData? session) {
    _controller.text = score.score.notes;
    DialogHelper.showTextEditDialog(
      context: context,
      controller: _controller,
      name: "Notes",
      validator: () => null,
      handleSubmit: () {
        _handleSubmit(
          item: "Notes",
          score: score,
          session: session,
          newValue: _controller.text,
        );
      },
    );
  }

  void _resetOnClick({
    required ScoresProvider scoreNotifier,
    required GoogleSheetHelper sheetHelper,
    required ScoreWithDetails score,
    required UserSessionData? session,
  }) async {
    String message = 'Score updated successfully!';
    bool failed = false;
    final oldCatNum = score.score.catalogNumber;
    final oldCategory = score.category!.name;
    final newScore = await scoreNotifier.updateScoreFromObject(
      resetScore.score,
      resetScore.subcategories,
    );
    _selectedCategory = newScore.category;
    _selectedStatus = newScore.status;
    Future(() async {
      try {
        await _addScoreToSheet(
          scoresNotifier: scoreNotifier,
          sheetHelper: sheetHelper,
          score: newScore,
          session: session,
          oldCatNum: oldCatNum,
        );
        if (oldCategory != newScore.category?.name &&
            newScore.score.link != null &&
            newScore.score.link!.isNotEmpty) {
          final account = ref.read(googleSignInProvider);
          await DriveHelper.moveFile(
            account: account,
            parentFolderId: session!.driveFolderId!,
            oldFolderName: oldCategory,
            newFolderName: newScore.category!.name,
            fileAddress: newScore.score.link!,
          );
        }
      } on AddToSheetException catch (e) {
        message = "Failed to reset Sheet: ${e.message}";
        failed = true;
        await scoreNotifier.updateScoreFromObject(
          score.score,
          score.subcategories,
        );
      }
      if (failed) {
        GlobalSnackbar.show(
          message: message,
          isError: failed,
          duration: Duration(seconds: 6),
          onRetry: () async {
            try {
              await scoreNotifier.updateScoreFromObject(
                newScore.score,
                newScore.subcategories,
              );
              await _addScoreToSheet(
                sheetHelper: sheetHelper,
                scoresNotifier: scoreNotifier,
                score: newScore,
                session: session,
                oldCatNum: oldCatNum,
              );
              if (oldCategory != newScore.category?.name &&
                  newScore.score.link != null &&
                  newScore.score.link!.isNotEmpty) {
                final account = ref.read(googleSignInProvider);
                await DriveHelper.moveFile(
                  account: account,
                  parentFolderId: session!.driveFolderId!,
                  oldFolderName: oldCategory,
                  newFolderName: newScore.category!.name,
                  fileAddress: newScore.score.link!,
                );
              }
            } catch (e) {
              GlobalSnackbar.show(
                message: "Retry failed: ${e.toString()}",
                isError: true,
                duration: const Duration(seconds: 6),
                onRetry: () {
                  _resetOnClick(
                    scoreNotifier: scoreNotifier,
                    sheetHelper: sheetHelper,
                    score: newScore,
                    session: session,
                  );
                },
              );
            }
          },
        );
      }
    });
  }

  Future<void> _deleteOnPressed({
    required ScoresProvider scoresNotifier,
    required GoogleSheetHelper sheetHelper,
    required ScoreWithDetails score,
    required UserSessionData? session,
  }) async {
    String message = "Successfully deleted score";
    bool failed = false;

    await scoresNotifier.removeScore(score.score);

    Future(() async {
      try {
        await sheetHelper.deleteRow(catalogNumber: score.score.catalogNumber);
      } on AddToSheetException catch (e) {
        if (!(e.message == "Score has already been deleted.")) {
          scoresNotifier.addScoreFromObject(score);
        }
        message = e.message;
        failed = true;
      } catch (e) {
        scoresNotifier.addScoreFromObject(score);
        message = e.toString();
      }
      GlobalSnackbar.show(
        message: message,
        isError: failed,
        duration: Duration(seconds: 6),
        onRetry: () async {
          try {
            await scoresNotifier.removeScore(score.score);
            await sheetHelper.deleteRow(
              catalogNumber: score.score.catalogNumber,
            );
          } catch (e) {
            if ((e is! AddToSheetException) ||
                (!(e.message == "Score has already been deleted."))) {
              await scoresNotifier.addScoreFromObject(score);
            }

            GlobalSnackbar.show(
              message: "Retry failed: ${e.toString()}",
              isError: true,
              duration: const Duration(seconds: 6),
              onRetry: () {
                _deleteOnPressed(
                  scoresNotifier: scoresNotifier,
                  sheetHelper: sheetHelper,
                  score: score,
                  session: session,
                );
              },
            );
          }
        },
      );
    });
  }

  Future<void> _showDeleteDialog({
    required WidgetRef ref,
    required ScoreWithDetails score,
    required UserSessionData? session,
  }) async {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Delete Score"),
          content: Text(
            'Are you sure you want to delete "${score.score.title}?"',
            overflow: TextOverflow.visible,
            softWrap: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text(
                "Cancel",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextButton(
              onPressed: () async {
                final scoresNotifier = ref.read(
                  scoresNotifierProvider.notifier,
                );
                final sheetHelper = await GoogleSheetHelper.fromRef(ref);
                await _deleteOnPressed(
                  scoresNotifier: scoresNotifier,
                  sheetHelper: sheetHelper,
                  score: score,
                  session: session,
                );
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                }
                if (!mounted) return;
                Navigator.pop(context);
              },
              child: Text(
                "Delete",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scoreAsync = ref.watch(scoreByIdProvider(widget.scoreId));
    final categoriesAsync = ref.watch(categoriesNotifierProvider);
    final sessionAsync = ref.watch(sessionProvider);

    return scoreAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
      data: (score) {
        return categoriesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Error: $e')),
          data: (categories) {
            return sessionAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
              data: (session) {
                return _buildContent(ref, context, score, categories, session);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildContent(
    WidgetRef ref,
    BuildContext context,
    ScoreWithDetails score,
    List<CategoryWithDetails> categories,
    UserSessionData? session,
  ) {
    if (!_initialized) {
      resetScore = score.clone();
      _selectedCategory = score.category;
      _selectedStatus = score.status;
      _selectedSubcategories
        ..clear()
        ..addAll(score.subcategories ?? {});
      if (session == null) {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
        return const SizedBox.shrink();
      }
      _scoreRefreshTime = session.sheetRefreshTime;
      _initialized = true;
    }

    return Scaffold(
      appBar: CustomAppBar(title: "View"),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.all(0),
            child: TextButton(
              onPressed: () {
                setState(() {
                  edit = (edit == "Edit") ? "Done" : "Edit";
                });
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(12, 8, 20, 0),
                minimumSize: Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                edit,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // First Field Section
                  ScoreFieldSection(
                    children: [
                      ViewEditField(
                        title: "Title",
                        item: score.score.title,
                        edit: edit,
                        handleSubmit: () => _titleSubmit(score, session),
                      ),
                      Divider(),

                      ViewEditField(
                        title: "Composer",
                        item:
                            (score.composer != null)
                                ? score.composer!.name
                                : "",
                        edit: edit,
                        handleSubmit: () => _composerSubmit(score, session),
                      ),
                      Divider(),

                      ViewEditField(
                        title: "Arranger",
                        item:
                            (score.score.arranger.isEmpty)
                                ? '(none)'
                                : score.score.arranger,
                        edit: edit,
                        handleSubmit: () => _arrangerSubmit(score, session),
                      ),
                    ],
                  ),

                  // Second Field Section
                  ScoreFieldSection(
                    children: [
                      ViewEditField(
                        title: "Category",
                        item:
                            (score.category != null)
                                ? score.category!.name
                                : '',
                        edit: edit,
                        handleSubmit:
                            () => _categorySubmit(score, categories, session),
                      ),
                      Divider(),

                      ViewEditField(
                        title: "Subcategories",
                        edit: edit,
                        item:
                            score.subcategories!.isNotEmpty
                                ? Align(
                                  alignment: Alignment.centerLeft,
                                  child: Wrap(
                                    spacing: 8,
                                    children:
                                        score.subcategories!.map((subcategory) {
                                          return Container(
                                            margin: EdgeInsets.only(top: 8),
                                            padding: EdgeInsets.symmetric(
                                              vertical: 6,
                                              horizontal: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Text(subcategory.name),
                                          );
                                        }).toList(),
                                  ),
                                )
                                : '(none)',

                        handleSubmit: () => _subCategorySubmit(score, session),
                      ),
                    ],
                  ),

                  // Third Score Field Section
                  ScoreFieldSection(
                    children: [
                      ViewEditField(
                        title: "Catalog Number",
                        item: score.score.catalogNumber,
                        edit: edit,
                        handleSubmit:
                            () => _catalogNumberSubmit(score, session),
                      ),
                      Divider(),

                      ViewEditField(
                        title: "Status",
                        edit: edit,
                        item: Row(
                          children: [
                            Icon(
                              score.status!.icon,
                              color: score.status!.color,
                            ),
                            SizedBox(width: 10),
                            Text(score.status!.title),
                          ],
                        ),
                        handleSubmit: () => _statusSubmit(score, session),
                      ),
                    ],
                  ),

                  ScoreFieldSection(
                    children: [
                      ViewEditField(
                        title: "Notes",
                        edit: edit,
                        item:
                            (score.score.notes.isEmpty)
                                ? '(none)'
                                : score.score.notes,
                        handleSubmit: () => _notesSubmit(score, session),
                      ),
                    ],
                  ),

                  ScoreFieldSection(
                    children: [
                      ViewEditField(
                        title: "Link",
                        edit: edit,
                        item:
                            _uploading
                                ? Row(
                                  children: const [
                                    SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text("Uploading..."),
                                  ],
                                )
                                : (score.score.link != null &&
                                    score.score.link!.isNotEmpty)
                                ? score.score.link!
                                : '(none)',
                        handleSubmit: () => _linkSubmit(score, session),
                      ),
                      if (!_uploading) ...[
                        SizedBox(height: 8),
                        Divider(),
                        (score.score.link != null &&
                                score.score.link!.isNotEmpty)
                            ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton.icon(
                                  icon: const Icon(Icons.open_in_new),
                                  label: const Text('Open'),
                                  onPressed:
                                      () => launchUrl(
                                        Uri.parse(score.score.link!),
                                      ),
                                ),
                                TextButton.icon(
                                  icon: const Icon(Icons.copy),
                                  label: const Text('Copy'),
                                  onPressed: () {
                                    Clipboard.setData(
                                      ClipboardData(text: score.score.link!),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Link copied to clipboard',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            )
                            : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton.icon(
                                  icon: const Icon(Icons.upload),
                                  label: const Text('Upload Score From Files'),
                                  onPressed: () async {
                                    setState(() => _uploading = true);
                                    await _uploadScoreOnPressed(
                                      score,
                                      session!,
                                    );
                                    setState(() => _uploading = false);
                                  },
                                ),
                              ],
                            ),
                      ],
                    ],
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
          BottomButtonsSection(
            edit: (edit == "Done"),
            onReset: () async {
              if (edit == "Done") {
                final scoreNotifier = ref.read(scoresNotifierProvider.notifier);
                final sheetHelper = await GoogleSheetHelper.fromRef(ref);
                _resetOnClick(
                  scoreNotifier: scoreNotifier,
                  sheetHelper: sheetHelper,
                  score: score,
                  session: session,
                );
                _selectedCategory = score.category;
                _selectedStatus = score.status;
              } else {
                Navigator.pop(context);
              }
            },
            onDelete: () async {
              await _showDeleteDialog(ref: ref, score: score, session: session);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _uploadScoreOnPressed(
    ScoreWithDetails score,
    UserSessionData session,
  ) async {
    final file = await DriveHelper.pickPdfFile();
    if (file == null) return;
    final account = ref.read(googleSignInProvider);
    final link = await DriveHelper.uploadPdfToDrive(
      file,
      account,
      session.driveFolderId!,
      score.category!.name,
    );
    if (link == null) return;

    await _handleSubmit(
      item: "Link",
      score: score,
      session: session,
      newValue: link,
    );
  }
}
