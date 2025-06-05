import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_app/database/library_database.dart';
import 'package:library_app/models/category_with_details.dart';
import 'package:library_app/models/status.dart';
import 'package:library_app/providers/categories_provider.dart';
import 'package:library_app/providers/scores_provider.dart';
import 'package:library_app/screens/home/home.dart';
import 'package:library_app/shared/gradient_button.dart';
import 'package:library_app/shared/status_card.dart';
import 'package:library_app/shared/appbar.dart';
import 'package:library_app/shared/custom_chip.dart';

class CreateScore extends ConsumerStatefulWidget {
  const CreateScore({super.key});

  @override
  ConsumerState<CreateScore> createState() => _CreateScoreState();
}

class _CreateScoreState extends ConsumerState<CreateScore> {
  String _title = '';
  String _composer = '';
  String? _arranger;
  String? _catalogNumber;
  String? _notes;

  CategoryWithDetails? _selectedCategory;
  final Set<SubcategoryData> _selectedSubcategories = {};
  Status _selectedStatus = Status.inLibrary;
  final Set<SubcategoryData> _subcategories = {};

  bool _isEditing = false;
  String? _catalogNumberError;
  final _formGlobalKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void updateStatus(Status status) {
    setState(() {
      FocusScope.of(context).unfocus();
      _selectedStatus = status;
    });
  }

  void addNewSubcategory() async {
    final newName = _controller.text.trim();
    if (newName.isEmpty || _selectedCategory == null) return;

    final categoryId = _selectedCategory!.category.id;

    final newSubcategory = SubcategoriesCompanion(
      categoryId: Value(categoryId),
      name: Value(newName),
    );

    final updatedCategory = await ref
        .read(categoriesNotifierProvider.notifier)
        .addSubcategory(newSubcategory);

    setState(() {
      _selectedCategory = updatedCategory;
      _subcategories
        ..clear()
        ..addAll(updatedCategory.subcategories ?? []);
      if (updatedCategory.subcategories != null) {
        _selectedSubcategories.add(
          updatedCategory.subcategories!.firstWhere((s) => (s.name == newName)),
        );
      }
      _controller.clear();
      _isEditing = false;
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _selectedCategory =
  //       ref.read(categoriesNotifierProvider).entries.first.value;
  // }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<String?> catalogValidiator(value) async {
    if (value == null || value.isEmpty) {
      if (_selectedCategory != null) {
        _catalogNumber =
            "${_selectedCategory!.category.identifier} ${await ref.read(scoresNotifierProvider.notifier).getNewCatalogNumber(_selectedCategory!.category.id)}";
      }
      return null;
    }
    final regex = RegExp(r'^[A-Za-z]+ \d{1,4}$');
    if (!regex.hasMatch(value)) {
      return 'Invalid format. Use: "Text 1234" \n(letters + space + up to 4 digits)';
    }
    final splitNumber = value.split(' ');
    if (splitNumber[0].trim().toUpperCase() !=
        _selectedCategory!.category.identifier) {
      return '${_selectedCategory!.category.name} numbers must start with ${_selectedCategory!.category.identifier}';
    }
    final isUnique = await ref
        .read(scoresNotifierProvider.notifier)
        .checkCatalogNumber(
          int.parse(splitNumber[1]),
          _selectedCategory!.category.id,
        );
    if (!isUnique) {
      return 'Catalog number has already been used';
    }
    return null;
  }

  void handleSubmit() async {
    final catalogError = await catalogValidiator(_catalogNumber);
    if (!mounted) return;
    if (catalogError != null) {
      setState(() {
        _catalogNumberError = catalogError;
      });
      return;
    }
    setState(() {
      _catalogNumberError = null;
    });
    if (_formGlobalKey.currentState!.validate()) {
      _formGlobalKey.currentState!.save();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).unfocus();
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirm Details"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Title: $_title",
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
                Text(
                  "Composer: $_composer",
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
                if (_arranger != null && _arranger!.isNotEmpty)
                  Text(
                    "Arranger: $_arranger",
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                Text(
                  "Catalog Number: $_catalogNumber",
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
                Text(
                  "Category: ${_selectedCategory!.category.name}",
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
                if (_selectedSubcategories.isNotEmpty)
                  Text(
                    "Subcategories: ${_selectedSubcategories.map((s) => s.name).join(', ')}",
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                Text("Status: ${_selectedStatus.title}"),
                if (_notes != null && _notes!.isNotEmpty)
                  Text(
                    "Notes: $_notes",
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  FocusScope.of(context).unfocus();
                  _catalogNumber = "";
                },
                child: Text(
                  "Edit",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextButton(
                onPressed: () async {
                  ComposerData? composer = await ref
                      .read(scoresNotifierProvider.notifier)
                      .getComposer(_composer);
                  composer ??= await ref
                      .read(scoresNotifierProvider.notifier)
                      .addComposer(_composer);

                  await ref.read(scoresNotifierProvider.notifier).addScore(
                    ScoresCompanion(
                      title: Value(_title),
                      composerId: Value(composer.id),
                      arranger:
                          (_arranger != null && _arranger!.isNotEmpty)
                              ? Value(_arranger!)
                              : Value.absent(),
                      catalogNumber: Value(
                        int.parse(_catalogNumber!.split(' ')[1]),
                      ),
                      notes:
                          (_notes != null && _notes!.isNotEmpty)
                              ? Value(_notes!)
                              : Value.absent(),
                      categoryId: Value(_selectedCategory!.category.id),
                      status: Value(_selectedStatus.title),
                      changeTime: Value(DateTime.now()),
                    ),
                    {..._selectedSubcategories},
                  );
                  _formGlobalKey.currentState!.reset();
                  _selectedSubcategories.clear();
                  _selectedCategory = null;
                  _selectedStatus = Status.inLibrary;

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollController.animateTo(
                      0.0,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                    FocusScope.of(context).unfocus();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (ctx) => const Home()),
                    );
                  });
                },
                child: Text(
                  "Confirm",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesNotifierProvider);
    return GestureDetector(
      onTap: () {
        setState(() {
          _isEditing = false;
          FocusScope.of(context).unfocus();
        });
      },
      child: Scaffold(
        appBar: CustomAppBar(title: "Add New Score"),

        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Form(
                  key: _formGlobalKey,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.red[400]),
                            label: Text(
                              "Title",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          style: Theme.of(context).textTheme.bodyMedium,
                          textInputAction: TextInputAction.next,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Title is required';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _title = value!;
                          },
                        ),
                        const SizedBox(height: 10),

                        TextFormField(
                          decoration: InputDecoration(
                            errorStyle: TextStyle(color: Colors.red[400]),
                            label: Text(
                              "Composer",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          style: Theme.of(context).textTheme.bodyMedium,
                          textInputAction: TextInputAction.next,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Composer is required';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _composer = value!;
                          },
                        ),
                        const SizedBox(height: 10),

                        TextFormField(
                          decoration: InputDecoration(
                            label: Text(
                              "Arranger (optional)",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          style: Theme.of(context).textTheme.bodyMedium,
                          textInputAction: TextInputAction.next,
                          onSaved: (value) {
                            _arranger = value;
                          },
                        ),
                        const SizedBox(height: 10),

                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Catalog Number (optional)",
                            labelStyle: Theme.of(context).textTheme.bodyMedium,
                            hintText: "XXX 0000",
                            errorMaxLines: 3,
                            errorStyle: TextStyle(color: Colors.red[400]),
                            errorText: _catalogNumberError,
                            hintStyle: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey),
                          ),
                          style: Theme.of(context).textTheme.bodyMedium,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            if (_catalogNumberError != null) {
                              setState(() {
                                _catalogNumberError = null;
                              });
                            }
                            _catalogNumber = value;
                          },
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<int>(
                          dropdownColor: Colors.grey[800],
                          value: _selectedCategory?.category.id,
                          decoration: InputDecoration(
                            labelText: "Category",
                            labelStyle: Theme.of(context).textTheme.bodyMedium,
                          ),
                          items: categories.when(
                            data: (categoryList) {
                              final items =
                                  categoryList.map((category) {
                                    return DropdownMenuItem<int>(
                                      alignment: AlignmentDirectional.center,
                                      value: category.category.id,
                                      child: Text(
                                        category.category.name,
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodyMedium,
                                      ),
                                    );
                                  }).toList();

                              items.add(
                                DropdownMenuItem<int>(
                                  value: -1,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "Add new category...",
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                              return items;
                            },
                            loading: () => [],
                            error: (err, stack) => [],
                          ),
                          onChanged: (newId) async {
                            if (newId == null) return;
                            if (newId == -1) {
                              final dialogFormKey = GlobalKey<FormState>();
                              String name = '';
                              String identifier = '';
                              final result = await showDialog<
                                Map<String, String>
                              >(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Add New Category"),
                                    content: Form(
                                      key: dialogFormKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            cursorColor: Colors.white,
                                            autofocus: true,
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                            decoration: InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                              labelText: "Category Name",
                                            ),
                                            onChanged: (value) => name = value,
                                            validator:
                                                (value) =>
                                                    value == null ||
                                                            value.trim().isEmpty
                                                        ? 'Required'
                                                        : null,
                                          ),
                                          SizedBox(height: 8),
                                          TextFormField(
                                            cursorColor: Colors.white,
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                            decoration: InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                              labelText:
                                                  "Letter Identifier (e.g. M)",
                                            ),
                                            maxLength: 10,
                                            onChanged:
                                                (value) => identifier = value,
                                            validator:
                                                (value) =>
                                                    value == null ||
                                                            value.trim().isEmpty
                                                        ? 'Required'
                                                        : null,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () => Navigator.of(context).pop(),
                                        child: Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          if (dialogFormKey.currentState!
                                              .validate()) {
                                            Navigator.of(context).pop({
                                              'name': name.trim(),
                                              'identifier':
                                                  identifier
                                                      .trim()
                                                      .toUpperCase(),
                                            });
                                          }
                                        },
                                        child: Text("Add"),
                                      ),
                                    ],
                                  );
                                },
                              );
                              if (result != null &&
                                  result['name']!.isNotEmpty &&
                                  result['identifier']!.isNotEmpty) {
                                final newCategory = await ref
                                    .read(categoriesNotifierProvider.notifier)
                                    .addCategory(
                                      CategoriesCompanion(
                                        name: Value(result['name']!),
                                        identifier: Value(
                                          result['identifier']!,
                                        ),
                                      ),
                                    );
                                setState(() {
                                  _selectedCategory = newCategory;
                                  _selectedSubcategories.clear();
                                  _subcategories
                                    ..clear()
                                    ..addAll(newCategory.subcategories ?? {});
                                });
                              }
                            } else {
                              final categoryList = categories.asData?.value;
                              if (categoryList == null) return;
                              final selected = categoryList.firstWhere(
                                (c) => c.category.id == newId,
                              );
                              setState(() {
                                _selectedCategory = selected;
                                _selectedSubcategories.clear();
                                _subcategories
                                  ..clear()
                                  ..addAll(selected.subcategories ?? {});
                              });
                            }
                          },
                          validator: (value) {
                            if (_selectedCategory == null) {
                              return 'Please select a category';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            final categoryList = categories.asData?.value;
                            if (categoryList != null &&
                                value != null &&
                                value != -1) {
                              _selectedCategory = categoryList.firstWhere(
                                (c) => c.category.id == value,
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 30),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Subcategories",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            spacing: 8,
                            children: [
                              ..._subcategories.map((subcategory) {
                                return CustomChoiceChip(
                                  label: subcategory.name,
                                  isSelected: _selectedSubcategories.contains(
                                    subcategory,
                                  ),
                                  onSelected: (selected) {
                                    FocusScope.of(context).unfocus();
                                    setState(() {
                                      if (selected) {
                                        _selectedSubcategories.add(subcategory);
                                      } else {
                                        _selectedSubcategories.remove(
                                          subcategory,
                                        );
                                      }
                                    });
                                  },
                                );
                              }),
                              if (_selectedCategory != null)
                                InkWell(
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    setState(() {
                                      _isEditing = true;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    margin: EdgeInsets.only(top: 5),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 7,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        255,
                                        152,
                                        56,
                                        56,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child:
                                        _isEditing
                                            ? SizedBox(
                                              width: 250,
                                              child: TextField(
                                                cursorColor: Colors.white,
                                                style:
                                                    Theme.of(
                                                      context,
                                                    ).textTheme.bodyMedium,
                                                controller: _controller,
                                                autofocus: true,
                                                onSubmitted: (value) {
                                                  addNewSubcategory();
                                                },
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                        vertical: 12,
                                                      ),
                                                  hintText:
                                                      "add new subcategory",
                                                  hintStyle: TextStyle(
                                                    color: const Color.fromARGB(
                                                      255,
                                                      218,
                                                      181,
                                                      181,
                                                    ),
                                                  ),
                                                  fillColor: Colors.transparent,
                                                  border: InputBorder.none,
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      Icons.check,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed:
                                                        addNewSubcategory,
                                                  ),
                                                ),
                                              ),
                                            )
                                            : Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Status",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: StatusCard(
                                status: Status.inLibrary,
                                onTap: updateStatus,
                                selected: _selectedStatus == Status.inLibrary,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: StatusCard(
                                status: Status.checkedOut,
                                onTap: updateStatus,
                                selected: _selectedStatus == Status.checkedOut,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: StatusCard(
                                status: Status.digitalOnly,
                                onTap: updateStatus,
                                selected: _selectedStatus == Status.digitalOnly,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: StatusCard(
                                status: Status.inBinder,
                                onTap: updateStatus,
                                selected: _selectedStatus == Status.inBinder,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: StatusCard(
                                status: Status.incomplete,
                                onTap: updateStatus,
                                selected: _selectedStatus == Status.incomplete,
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: StatusCard(
                                status: Status.missing,
                                onTap: updateStatus,
                                selected: _selectedStatus == Status.missing,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        TextFormField(
                          maxLines: null,
                          decoration: InputDecoration(
                            label: Text(
                              "Notes (optional)",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          style: Theme.of(context).textTheme.bodyMedium,
                          onSaved: (value) {
                            _notes = value;
                          },
                        ),
                      ],
                    ),
                  ),
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
                          Navigator.of(context).pop();
                        },
                        text: Text(
                          "Cancel",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        colorStart: Color.fromRGBO(87, 87, 87, 1),
                        colorEnd: Color.fromRGBO(37, 37, 37, 1),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 10, 8, 5),
                      child: GradientButton(
                        onPressed: handleSubmit,
                        text: Text(
                          "Submit",
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
      ),
    );
  }
}
