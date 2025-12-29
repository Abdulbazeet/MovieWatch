import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_watch/data/tmdb_providers.dart';
import 'package:movie_watch/data/tmdb_services.dart';
import 'package:movie_watch/models/search/search_results.dart';

class SearchResultsNotifier extends AsyncNotifier<List<SearchResults>> {
  @override
  FutureOr<List<SearchResults>> build() {
    return Future.value([]);
  }

  Future<void> searchQuery(String query) async {
    state = const AsyncLoading();
    try {
      var results = await ref
          .read(tmdbserviceProvider)
          .fetchSearchResults(query);
      state = AsyncData(results);
    } catch (e, str) {
      state = AsyncError(e, str);
    }
  }
}

final searchResultsNotifierProvider =
    AsyncNotifierProvider<SearchResultsNotifier, List<SearchResults>>(
      () => SearchResultsNotifier(),
    );
