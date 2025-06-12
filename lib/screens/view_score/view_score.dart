import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_app/database/library_database.dart';
import 'package:library_app/models/category_with_details.dart';
import 'package:library_app/models/score_with_details.dart';
import 'package:library_app/models/status.dart';
import 'package:library_app/providers/categories_provider.dart';
import 'package:library_app/providers/scores_provider.dart';
import 'package:library_app/screens/view_score/score_field.dart';
import 'package:library_app/screens/view_score/view_edit_field.dart';
import 'package:library_app/shared/app_drawer.dart';
import 'package:library_app/shared/appbar.dart';
import 'package:library_app/screens/view_score/show_dialog.dart';
import 'package:library_app/shared/gradient_button.dart';

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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _titleSubmit(ScoreData score) {
    _controller.text = score.title;
    DialogHelper.showTextEditDialog(
      context: context,
      name: "Title",
      controller: _controller,
      validator:
          () => _controller.text.isEmpty ? "Title cannot be empty" : null,
      handleSubmit: () {
        ref
            .read(scoresNotifierProvider.notifier)
            .updateScore('title', _controller.text, score.id);
      },
    );
  }

  void _composerSubmit(ScoreWithDetails score) {
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
        ref
            .read(scoresNotifierProvider.notifier)
            .updateScore('composer', composer.id, score.score.id);
      },
    );
  }

  void _arrangerSubmit(ScoreData score) {
    _controller.text = score.arranger;
    DialogHelper.showTextEditDialog(
      context: context,
      controller: _controller,
      name: "Arranger",
      validator: () => null,
      handleSubmit: () {
        ref
            .read(scoresNotifierProvider.notifier)
            .updateScore('arranger', _controller.text, score.id);
      },
    );
  }

  void _categorySubmit(
    ScoreWithDetails score,
    List<CategoryWithDetails> categories,
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
          ref
              .read(scoresNotifierProvider.notifier)
              .updateScore('category', _selectedCategory!.id, score.score.id);
          final newCatalogNum = await ref
              .read(scoresNotifierProvider.notifier)
              .getNewCatalogNumber(
                _selectedCategory!.id,
                _selectedCategory!.identifier,
              );
          ref
              .read(scoresNotifierProvider.notifier)
              .updateScore('catalog_number', newCatalogNum, score.score.id);
        }
      },
    );
  }

  void _subCategorySubmit(ScoreWithDetails score) async {
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
        ref.read(scoresNotifierProvider.notifier).updateScore('subcategories', {
          ..._selectedSubcategories,
        }, score.score.id);
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

  void _catalogNumberSubmit(ScoreWithDetails score) async {
    _controller.text = score.score.catalogNumber;
    DialogHelper.showCatalogEditDialog(
      context: context,
      name: "Catalog Number",
      controller: _controller,
      validator: () => _catalogValidiator(_controller.text),
      handleSubmit: () {
        ref
            .read(scoresNotifierProvider.notifier)
            .updateScore('catalog_number', _controller.text, score.score.id);
      },
    );
  }

  void _statusSubmit(ScoreData score) {
    DialogHelper.showStatusDialog(
      context: context,
      selectedStatus: _selectedStatus,
      onStatusSelect: (status) => _selectedStatus = status,
      name: "Status",
      handleSubmit: () {
        if (_selectedStatus == null) return;
        ref
            .read(scoresNotifierProvider.notifier)
            .updateScore('status', _selectedStatus!.title, score.id);
      },
    );
  }

  void _notesSubmit(ScoreData score) {
    _controller.text = score.notes;
    DialogHelper.showTextEditDialog(
      context: context,
      controller: _controller,
      name: "Notes",
      validator: () => null,
      handleSubmit: () {
        ref
            .read(scoresNotifierProvider.notifier)
            .updateScore('notes', _controller.text, score.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scoreAsync = ref.watch(scoreByIdProvider(widget.scoreId));
    final categoriesAsync = ref.watch(categoriesNotifierProvider);

    return scoreAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
      data: (score) {
        return categoriesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Error: $e')),
          data: (categories) {
            if (!_initialized) {
              resetScore = score.clone();
              _selectedCategory = score.category;
              _selectedStatus = score.status;
              _selectedSubcategories
                ..clear()
                ..addAll(score.subcategories ?? {});
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
                                handleSubmit: () => _titleSubmit(score.score),
                              ),
                              Divider(),

                              ViewEditField(
                                title: "Composer",
                                item:
                                    (score.composer != null)
                                        ? score.composer!.name
                                        : "",
                                edit: edit,
                                handleSubmit: () => _composerSubmit(score),
                              ),
                              Divider(),

                              ViewEditField(
                                title: "Arranger",
                                item:
                                    (score.score.arranger.isEmpty)
                                        ? '(none)'
                                        : score.score.arranger,
                                edit: edit,
                                handleSubmit:
                                    () => _arrangerSubmit(score.score),
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
                                    () => _categorySubmit(score, categories),
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
                                                score.subcategories!.map((
                                                  subcategory,
                                                ) {
                                                  return Container(
                                                    margin: EdgeInsets.only(
                                                      top: 8,
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          vertical: 6,
                                                          horizontal: 10,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                        width: 2,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            5,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      subcategory.name,
                                                    ),
                                                  );
                                                }).toList(),
                                          ),
                                        )
                                        : '(none)',

                                handleSubmit: () => _subCategorySubmit(score),
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
                                handleSubmit: () => _catalogNumberSubmit(score),
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
                                handleSubmit: () => _statusSubmit(score.score),
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
                                handleSubmit: () => _notesSubmit(score.score),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 10, 4, 5),
                            child: GradientButton(
                              onPressed: () {
                                if (edit == "Done") {
                                  ref
                                      .read(scoresNotifierProvider.notifier)
                                      .updateScoreFromObject(
                                        resetScore.score,
                                        resetScore.subcategories,
                                      );
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                              colorStart: Color.fromRGBO(87, 87, 87, 1),
                              colorEnd: Color.fromRGBO(37, 37, 37, 1),
                              text: Text(
                                (edit == "Done") ? "Reset" : "Back",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(4, 10, 8, 5),
                            child: GradientButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return AlertDialog(
                                      title: const Text("Delete Score"),
                                      content: Text(
                                        "Are you sure you want to delete ${score.score.title}?",
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
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.titleMedium,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            ref
                                                .read(
                                                  scoresNotifierProvider
                                                      .notifier,
                                                )
                                                .removeScore(score.score);

                                            Navigator.pop(ctx);
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Delete",
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.titleMedium,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              text: Text(
                                "Delete Score",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
