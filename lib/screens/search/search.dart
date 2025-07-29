import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_app/models/category_with_details.dart';
import 'package:library_app/providers/categories_provider.dart';
import 'package:library_app/providers/scores_provider.dart';
import 'package:library_app/providers/search_provider.dart';
import 'package:library_app/screens/search/score_card.dart';
import 'package:library_app/shared/app_drawer.dart';
import 'package:library_app/shared/appbar.dart';
import 'package:library_app/shared/gradient_button.dart';

class Search extends ConsumerStatefulWidget {
  const Search({super.key});

  @override
  ConsumerState<Search> createState() => _SearchState();
}

class _SearchState extends ConsumerState<Search> with TickerProviderStateMixin {
  bool _isExpanded = true;
  bool _isAdvancedSearch = false;
  CategoryWithDetails? _selectedCategory;
  String? _selectedSubcategory;
  late ScrollController _scrollController;
  bool _didClearFilters = false;
  final _mainSearchController = TextEditingController();
  final _titleController = TextEditingController();
  final _composerController = TextEditingController();
  final _arrangerController = TextEditingController();
  final _catalogNumController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final scrollOffset = _scrollController.position.pixels;
      final isScrollingDown = scrollOffset > 100;

      if (_isExpanded && isScrollingDown) {
        setState(() {
          _isExpanded = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _mainSearchController.dispose();
    _titleController.dispose();
    _composerController.dispose();
    _arrangerController.dispose();
    _catalogNumController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_mainSearchController.text.isEmpty && !_didClearFilters) {
      _didClearFilters = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(searchQueryProvider.notifier).update('');
        ref.read(advancedFiltersProvider.notifier).state =
            AdvancedSearchFilters();
        _clearFiltersIfEmptySearch();
      });
    }
  }

  void _clearFiltersIfEmptySearch() {
    if (_mainSearchController.text.isEmpty) {
      _titleController.clear();
      _composerController.clear();
      _arrangerController.clear();
      _catalogNumController.clear();
      _selectedCategory = null;
      _selectedSubcategory = null;
    }
  }

  void _clearAndSyncSearch() {
    _mainSearchController.clear();
    _titleController.clear();
    _composerController.clear();
    _arrangerController.clear();
    _catalogNumController.clear();
    _selectedCategory = null;
    _selectedSubcategory = null;
    ref.read(searchQueryProvider.notifier).update('');
    _updateFilters();
  }

  void _updateFilters() {
    ref.read(advancedFiltersProvider.notifier).state = AdvancedSearchFilters(
      title: _titleController.text,
      composer: _composerController.text,
      arranger: _arrangerController.text,
      catalogNumber: _catalogNumController.text,
      categoryName: _selectedCategory?.category.name,
      subcategoryName: _selectedSubcategory,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scoresAsync = ref.watch(scoresNotifierProvider);
    final categoriesAsync = ref.watch(categoriesNotifierProvider);
    final results = ref.watch(filteredScoresProvider);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 37, 36, 37),
      appBar: CustomAppBar(title: "Search"),
      drawer: AppDrawer(),
      body: categoriesAsync.when(
        data: (categories) {
          return scoresAsync.when(
            data: (scores) {
              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child:
                          (results.isNotEmpty)
                              ? ListView.builder(
                                controller: _scrollController,
                                itemCount: results.length,
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    return const SizedBox(height: 8);
                                  }
                                  final score = results[index - 1];
                                  return ScoreCard(score: score);
                                },
                              )
                              : _noItems(),
                    ),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: _buildSearchOptions(categories),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text("Error loading scores: $e")),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text("Error loading categories: $e")),
      ),
    );
  }

  Widget _buildSearchOptions(List<CategoryWithDetails> categories) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.dy < -5) {
          setState(() => _isExpanded = true);
        } else if (details.delta.dy > 5) {
          setState(() => _isExpanded = false);
        }
      },
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 72, 72, 72),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black38)],
          ),
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 30,
                  height: 4,
                  margin: EdgeInsets.fromLTRB(0, 8, 0, 16),
                  color: const Color.fromARGB(130, 255, 255, 255),
                ),
              ),
              if (_isExpanded) ...[
                if (!_isAdvancedSearch) _buildAllFieldsInput(),
                if (_isAdvancedSearch) ...[
                  _buildTextField("Title", _titleController),
                  _buildTextField("Composer", _composerController),
                  _buildTextField("Arranger", _arrangerController),
                  _buildTextField("Catalog Number", _catalogNumController),
                  _buildDropdown<CategoryWithDetails>(
                    "Category",
                    categories.map((entry) {
                      return DropdownMenuItem<CategoryWithDetails>(
                        value: entry,
                        child: Text(
                          entry.category.name,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }).toList(),
                    _selectedCategory,
                    (value) {
                      setState(() {
                        _selectedCategory = value;
                        _selectedSubcategory = null;
                      });
                      _updateFilters();
                    },
                  ),
                  if (_selectedCategory?.subcategories?.isNotEmpty ?? false)
                    _buildDropdown<String>(
                      "Subcategory",
                      _selectedCategory!.subcategories!.map((entry) {
                        return DropdownMenuItem<String>(
                          value: entry.name,
                          child: Text(
                            entry.name,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        );
                      }).toList(),
                      _selectedSubcategory,
                      (value) {
                        setState(() => _selectedSubcategory = value);
                        _updateFilters();
                      },
                    ),
                ],
                const SizedBox(height: 8),
                _moreSearchButton(),
                const SizedBox(height: 8),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAllFieldsInput() {
    return TextFormField(
      controller: _mainSearchController,
      textAlignVertical: TextAlignVertical.center,
      style: Theme.of(context).textTheme.bodyMedium,
      onChanged: (val) => ref.read(searchQueryProvider.notifier).update(val),
      cursorColor: Colors.grey[300],
      decoration: InputDecoration(
        border: InputBorder.none,
        fillColor: const Color.fromARGB(20, 255, 255, 255),
        // fillColor: const Color.fromARGB(255, 110, 110, 110),
        // fillColor: Colors.grey[850],
        hintText: "search all fields",
        hintStyle: Theme.of(
          context,
        ).textTheme.bodyMedium!.copyWith(fontStyle: FontStyle.italic),
        prefixIcon: const Icon(Icons.search, color: Colors.white),
      ),
    );
  }

  Widget _moreSearchButton() {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          // const Color.fromARGB(60, 255, 255, 255),
          const Color.fromARGB(123, 255, 0, 0),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _isAdvancedSearch ? "fewer search options" : "more search options",
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
      onPressed: () {
        setState(() {
          _isAdvancedSearch = !_isAdvancedSearch;
          _clearAndSyncSearch();
        });
      },
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: TextFormField(
        controller: controller,
        onChanged: (val) {
          _updateFilters();
        },
        cursorColor: Colors.grey[300],
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          suffixIcon: const Icon(
            Icons.search,
            color: Color.fromRGBO(224, 224, 224, 1),
            // color: Color.fromRGBO(189, 189, 189, 1),
          ),
          fillColor: const Color.fromARGB(20, 255, 255, 255),
          // fillColor: Colors.grey[850],
        ),
      ),
    );
  }

  Widget _buildDropdown<T>(
    String label,
    List<DropdownMenuItem<T>> items,
    T? selectedValue,
    void Function(T?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: DropdownButtonFormField<T>(
        dropdownColor: const Color.fromARGB(255, 90, 90, 90),
        // dropdownColor: Colors.grey[800],
        value: selectedValue,
        iconEnabledColor: Colors.grey[300],
        decoration: InputDecoration(
          border: InputBorder.none,
          fillColor: const Color.fromARGB(20, 255, 255, 255),
          // fillColor: Colors.grey[850],
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
        ),
        items: items,
        onChanged: onChanged,
      ),
    );
  }

  Widget _noItems() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "No scores found",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 30),
          Image.asset('assets/img/sad_redbull.png', height: 200),
        ],
      ),
    );
  }
}
