import 'package:flutter/material.dart';
import 'package:library_app/database/library_database.dart';
import 'package:library_app/models/category_with_details.dart';
import 'package:library_app/models/status.dart';
import 'package:library_app/shared/category_card.dart';
import 'package:library_app/shared/custom_chip.dart';
import 'package:library_app/shared/custom_text_field.dart';
import 'package:library_app/shared/status_card.dart';

class DialogHelper {
  static void showTextEditDialog({
    required BuildContext context,
    required String name,
    required TextEditingController controller,
    required void Function() handleSubmit,
    required String? Function() validator,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? errorMessage;
        String? exception;

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text("Edit $name"),
              content:
                  (exception == null)
                      ? CustomTextField(
                        textController: controller,
                        errorMessage: errorMessage,
                      )
                      : _errorText(error: exception),
              actions:
                  (exception == null)
                      ? _buildDialogActions(
                        context: context,
                        onConfirm: () {
                          try {
                            final error = validator();
                            if (error == null) {
                              handleSubmit();
                              Navigator.of(context).pop();
                            } else {
                              setStateDialog(() {
                                errorMessage = error;
                              });
                            }
                          } catch (e) {
                            setStateDialog(() {
                              exception = e.toString();
                            });
                          }
                        },
                      )
                      : _buildErrorActions(context: context),
            );
          },
        );
      },
    );
  }

  static void showCatalogEditDialog({
    required BuildContext context,
    required String name,
    required TextEditingController controller,
    required void Function() handleSubmit,
    required Future<String?> Function() validator,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? errorMessage;
        String? exception;
        final navigator = Navigator.of(context);

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text("Edit $name"),
              content:
                  (exception == null)
                      ? CustomTextField(
                        textController: controller,
                        errorMessage: errorMessage,
                      )
                      : _errorText(error: exception),
              actions:
                  (exception == null)
                      ? _buildDialogActions(
                        context: context,
                        onConfirm: () async {
                          try {
                            final error = await validator();
                            if (error == null) {
                              handleSubmit();
                              navigator.pop();
                            } else {
                              setStateDialog(() {
                                errorMessage = error;
                              });
                            }
                          } catch (e) {
                            setStateDialog(() {
                              exception = e.toString();
                            });
                          }
                        },
                      )
                      : _buildErrorActions(context: context),
            );
          },
        );
      },
    );
  }

  static void showCatalogDialog({
    required BuildContext context,
    required String name,
    required List<CategoryWithDetails> categories,
    required dynamic selectedCategory,
    required void Function(dynamic) onCategorySelect,
    required void Function() handleSubmit,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? exception;

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text("Edit $name"),
              content:
                  (exception == null)
                      ? Container(
                        width: double.maxFinite,
                        constraints: BoxConstraints(maxHeight: 300),
                        child: ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (_, index) {
                            var entry = categories[index];
                            return CategoryCard(
                              category: entry.category,
                              onTap: (category) {
                                setStateDialog(() {
                                  selectedCategory = category;
                                });
                                onCategorySelect(category);
                              },
                              selected: selectedCategory == entry.category,
                            );
                          },
                        ),
                      )
                      : _errorText(error: exception),
              actions:
                  (exception == null)
                      ? _buildDialogActions(
                        context: context,
                        onConfirm: () {
                          try {
                            handleSubmit();
                            Navigator.of(context).pop();
                          } catch (e) {
                            setStateDialog(() {
                              exception = e.toString();
                            });
                          }
                        },
                      )
                      : _buildErrorActions(context: context),
            );
          },
        );
      },
    );
  }

  static void showStatusDialog({
    required BuildContext context,
    required String name,
    required dynamic selectedStatus,
    required void Function(dynamic) onStatusSelect,
    required void Function() handleSubmit,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? exception;

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text("Edit $name"),
              content:
                  (exception == null)
                      ? Container(
                        width: double.maxFinite,
                        constraints: BoxConstraints(maxHeight: 350),
                        child: ListView.builder(
                          itemCount: Status.values.length,
                          itemBuilder: (_, index) {
                            var entry = Status.values[index];
                            return StatusCard(
                              status: entry,
                              onTap: (status) {
                                setStateDialog(() {
                                  selectedStatus = status;
                                });
                                onStatusSelect(status);
                              },
                              selected: selectedStatus == entry,
                            );
                          },
                        ),
                      )
                      : _errorText(error: exception),
              actions:
                  (exception == null)
                      ? _buildDialogActions(
                        context: context,
                        onConfirm: () {
                          try {
                            handleSubmit();
                            Navigator.of(context).pop();
                          } catch (e) {
                            setStateDialog(() {
                              exception = e.toString();
                            });
                          }
                        },
                      )
                      : _buildErrorActions(context: context),
            );
          },
        );
      },
    );
  }

  static void showSubcategoriesDialog({
    required BuildContext context,
    required String name,
    required CategoryData selectedCategory,
    required List<SubcategoryData>? categorySubcategories,
    required Set<SubcategoryData> selectedSubcategories,
    required TextEditingController controller,
    required Future<SubcategoryData?> Function(String) onAddSubcategory,
    required void Function(Set<SubcategoryData>) handleSubmit,
  }) {
    bool isEditing = false;
    final currentSelection = {...selectedSubcategories};
    final localSubcategories = [...categorySubcategories ?? []];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? exception;

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text("Edit $name"),
              content:
                  (exception == null)
                      ? Container(
                        width: double.maxFinite,
                        constraints: BoxConstraints(maxHeight: 300),
                        child: Wrap(
                          spacing: 8,
                          children: [
                            ...localSubcategories.map((subcategory) {
                              return CustomChoiceChip(
                                label: subcategory.name,
                                isSelected: currentSelection.contains(
                                  subcategory,
                                ),
                                onSelected: (selected) {
                                  setStateDialog(() {
                                    isEditing = false;
                                    if (selected) {
                                      currentSelection.add(subcategory);
                                    } else {
                                      currentSelection.remove(subcategory);
                                    }
                                  });
                                },
                              );
                            }),
                            InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
                                setStateDialog(() {
                                  isEditing = true;
                                });
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: _buildAddSubcategoryButton(
                                context,
                                isEditing,
                                controller,
                                setStateDialog,
                                (String newName) async {
                                  final newSub = await onAddSubcategory(
                                    newName,
                                  );
                                  if (newSub != null) {
                                    setStateDialog(() {
                                      localSubcategories.add(newSub);
                                      currentSelection.add(newSub);
                                    });
                                  }
                                },
                                (bool value) {
                                  setStateDialog(() {
                                    isEditing = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                      : _errorText(error: exception),
              actions:
                  (exception == null)
                      ? _buildDialogActions(
                        context: context,
                        onConfirm: () {
                          try {
                            handleSubmit(currentSelection);
                            Navigator.of(context).pop();
                          } catch (e) {
                            setStateDialog(() {
                              exception = e.toString();
                            });
                          }
                        },
                      )
                      : _buildErrorActions(context: context),
            );
          },
        );
      },
    );
  }

  static Widget _errorText({required error}) {
    return Text("A system error has occurred: $error");
  }

  static Widget _buildAddSubcategoryButton(
    BuildContext context,
    bool isEditing,
    TextEditingController controller,
    void Function(void Function()) setStateDialog,
    void Function(String) onAddSubcategory,
    void Function(bool) setEditingState,
  ) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 152, 56, 56),
        borderRadius: BorderRadius.circular(8),
      ),
      child:
          isEditing
              ? SizedBox(
                width: 250,
                child: TextField(
                  cursorColor: Colors.white,
                  style: Theme.of(context).textTheme.bodyMedium,
                  controller: controller,
                  autofocus: true,
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      setStateDialog(() {
                        onAddSubcategory(value);
                        controller.clear();
                        setEditingState(false);
                      });
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                    hintText: "Add new subcategory",
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 218, 181, 181),
                    ),
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.check, color: Colors.white),
                      onPressed: () {
                        if (controller.text.isNotEmpty) {
                          setStateDialog(() {
                            onAddSubcategory(controller.text);
                            controller.clear();
                          });
                        }
                        setEditingState(false);
                      },
                    ),
                  ),
                ),
              )
              : GestureDetector(
                onTap: () {
                  setEditingState(true);
                },
                child: Icon(Icons.add, color: Colors.white),
              ),
    );
  }

  static List<Widget> _buildDialogActions({
    required BuildContext context,
    required void Function() onConfirm,
  }) {
    return [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text("Cancel", style: Theme.of(context).textTheme.titleMedium),
      ),
      TextButton(
        onPressed: onConfirm,
        child: Text("Confirm", style: Theme.of(context).textTheme.titleMedium),
      ),
    ];
  }

  static List<Widget> _buildErrorActions({required BuildContext context}) {
    return [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text("Cancel", style: Theme.of(context).textTheme.titleMedium),
      ),
      TextButton(
        onPressed: () {},
        child: Text("Report", style: Theme.of(context).textTheme.titleMedium),
      ),
    ];
  }
}
