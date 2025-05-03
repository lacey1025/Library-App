import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_app/models/category_with_details.dart';
import 'package:library_app/providers/categories_provider.dart';
import 'package:library_app/providers/scores_provider.dart';
import 'package:library_app/screens/search/score_card.dart';
import 'package:library_app/shared/appbar.dart';

class Search extends ConsumerStatefulWidget {
  const Search({super.key});

  @override
  ConsumerState<Search> createState() => _SearchState();
}

class _SearchState extends ConsumerState<Search> with TickerProviderStateMixin {
  bool _isExpanded = false;
  bool _atTop = true;
  CategoryWithDetails? _selectedCategory;
  String? _selectedSubcategory;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      bool isAtTop = _scrollController.position.pixels <= 0;
      if (_atTop != isAtTop) {
        setState(() {
          _atTop = isAtTop;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scoresAsync = ref.watch(scoresNotifierProvider);
    final categoriesAsync = ref.watch(categoriesNotifierProvider);

    return Scaffold(
      appBar: CustomAppBar(title: "Search"),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: categoriesAsync.when(
          data: (categories) {
            return scoresAsync.when(
              data: (scores) {
                return Column(
                  children: [
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child:
                          _atTop
                              ? _buildSearchOptions(categories)
                              : const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 5),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: scores.length,
                        itemBuilder: (_, index) {
                          return ScoreCard(score: scores[index]);
                        },
                      ),
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
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   final scores = ref.watch(scoresNotifierProvider);
  //   final categories = ref.watch(categoryNotifierProvider);

  //   return Scaffold(
  //     appBar: CustomAppBar(title: "Search"),
  //     body: Container(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         children: [
  //           AnimatedSize(
  //             duration: const Duration(milliseconds: 300),
  //             curve: Curves.easeInOut,
  //             child:
  //                 _atTop
  //                     ? _buildSearchOptions(categories)
  //                     : const SizedBox.shrink(),
  //           ),
  //           const SizedBox(height: 5),
  //           Expanded(
  //             child: ListView.builder(
  //               controller: _scrollController,
  //               itemCount: scores.length,
  //               itemBuilder: (_, index) {
  //                 return ScoreCard(score: scores[index]);
  //               },
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildSearchOptions(List<CategoryWithDetails> categories) {
    return Column(
      children: [
        if (!_isExpanded)
          TextFormField(
            decoration: InputDecoration(
              hintText: "search all scores",
              hintStyle: TextStyle(color: Colors.white),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {},
              ),
            ),
          ),
        if (_isExpanded) ...[
          const SizedBox(height: 5),
          _buildTextField("Title"),
          _buildTextField("Composer"),
          _buildTextField("Arranger"),
          _buildTextField("Catalog Number"),
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
            (value) => setState(() {
              _selectedCategory = value;
              _selectedSubcategory = null;
            }),
          ),
          if (_selectedCategory != null &&
              _selectedCategory!.subcategories != null &&
              _selectedCategory!.subcategories!.isNotEmpty)
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
              (value) => setState(() => _selectedSubcategory = value),
            ),
        ],
        const SizedBox(height: 5),
        TextButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
              const Color.fromARGB(106, 255, 0, 0),
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isExpanded ? "less search options" : "more search options",
                style: const TextStyle(color: Colors.white),
              ),
              Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.white,
              ),
            ],
          ),
          onPressed: () => setState(() => _isExpanded = !_isExpanded),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          suffixIcon: const Icon(Icons.search, color: Colors.white),
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
        dropdownColor: Colors.grey[800],
        value: selectedValue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
        ),
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}
