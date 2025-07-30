import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_app/models/score_with_details.dart';
import 'package:library_app/providers/scores_provider.dart';
import 'package:fuzzy/fuzzy.dart';

final searchQueryProvider = StateNotifierProvider<SearchQueryNotifier, String>((
  ref,
) {
  return SearchQueryNotifier();
});

class SearchQueryNotifier extends StateNotifier<String> {
  SearchQueryNotifier() : super('');
  Timer? _debounce;

  void update(String input) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      state = input;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

final advancedFiltersProvider = StateProvider<AdvancedSearchFilters>(
  (ref) => AdvancedSearchFilters(),
);

class AdvancedSearchFilters {
  final String title;
  final String composer;
  final String arranger;
  final String catalogNumber;
  final String? categoryName;
  final String? subcategoryName;

  AdvancedSearchFilters({
    this.title = '',
    this.composer = '',
    this.arranger = '',
    this.catalogNumber = '',
    this.categoryName,
    this.subcategoryName,
  });

  bool get isEmpty =>
      [title, composer, arranger, catalogNumber].every((s) => s.isEmpty) &&
      categoryName == null &&
      subcategoryName == null;
}

final filteredScoresProvider = Provider<List<ScoreWithDetails>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase().trim();
  final filters = ref.watch(advancedFiltersProvider);
  final allScoresAsync = ref.watch(scoresNotifierProvider);

  return allScoresAsync.when(
    data: (scores) {
      if (query.isEmpty && filters.isEmpty) return scores;

      if (query.isNotEmpty) {
        final fuzzy = Fuzzy<ScoreWithDetails>(
          scores,
          options: FuzzyOptions<ScoreWithDetails>(
            keys: [
              WeightedKey<ScoreWithDetails>(
                name: 'title',
                getter: (s) => s.score.title,
                weight: 1.0,
              ),
              WeightedKey<ScoreWithDetails>(
                name: 'catalogNumber',
                getter: (s) => s.score.catalogNumber,
                weight: 0.8,
              ),
              WeightedKey<ScoreWithDetails>(
                name: 'composer',
                getter: (s) => s.composer?.name ?? '',
                weight: 0.9,
              ),
              WeightedKey<ScoreWithDetails>(
                name: 'category',
                getter: (s) => s.category?.name ?? '',
                weight: 0.6,
              ),
              WeightedKey<ScoreWithDetails>(
                name: 'arranger',
                getter: (s) => s.score.arranger,
                weight: 0.7,
              ),
              WeightedKey<ScoreWithDetails>(
                name: 'subcategories',
                getter:
                    (s) =>
                        s.subcategories?.map((sc) => sc.name).join(' ') ?? '',
                weight: 0.5,
              ),
            ],
            threshold: 0.2,
          ),
        );
        return fuzzy.search(query).map((r) => r.item).toList();
      }

      Iterable<ScoreWithDetails> advancedFiltered = scores;

      if (filters.title.isNotEmpty) {
        final fuzzyTitle = Fuzzy(
          advancedFiltered.toList(),
          options: FuzzyOptions<ScoreWithDetails>(
            threshold: 0.3,
            keys: [
              WeightedKey<ScoreWithDetails>(
                name: 'title',
                getter: (s) => s.score.title,
                weight: 1.0,
              ),
            ],
          ),
        );
        advancedFiltered = fuzzyTitle.search(filters.title).map((r) => r.item);
      }

      if (filters.composer.isNotEmpty) {
        final fuzzyComposer = Fuzzy(
          advancedFiltered.toList(),
          options: FuzzyOptions<ScoreWithDetails>(
            threshold: 0.3,
            keys: [
              WeightedKey<ScoreWithDetails>(
                name: 'composer',
                getter: (s) => s.composer?.name ?? '',
                weight: 1.0,
              ),
            ],
          ),
        );
        advancedFiltered = fuzzyComposer
            .search(filters.composer)
            .map((r) => r.item);
      }

      if (filters.arranger.isNotEmpty) {
        final fuzzyArranger = Fuzzy(
          advancedFiltered.toList(),
          options: FuzzyOptions<ScoreWithDetails>(
            threshold: 0.3,
            keys: [
              WeightedKey<ScoreWithDetails>(
                name: 'arranger',
                getter: (s) => s.score.arranger,
                weight: 1.0,
              ),
            ],
          ),
        );
        advancedFiltered = fuzzyArranger
            .search(filters.arranger)
            .map((r) => r.item);
      }

      return advancedFiltered.where((s) {
        final matchCatalog =
            filters.catalogNumber.isEmpty ||
            s.score.catalogNumber.toLowerCase().contains(
              filters.catalogNumber.toLowerCase(),
            );
        final matchCategory =
            filters.categoryName == null ||
            (s.category?.name == filters.categoryName);
        final matchSubcategory =
            filters.subcategoryName == null ||
            (s.subcategories?.any((sc) => sc.name == filters.subcategoryName) ??
                false);
        return matchCatalog && matchCategory && matchSubcategory;
      }).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});
