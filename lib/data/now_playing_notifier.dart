import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_watch/data/tmdb_providers.dart';
import 'package:movie_watch/models/movies.dart';
import 'package:riverpod/legacy.dart';

class NowPlayingMovieNotifier extends AsyncNotifier<List<Movie>> {
  int _page = 1;
  bool _hasMore = true;

  @override
  FutureOr<List<Movie>> build() async {
    // TODO: implement build
    return _fetchPage(reset: true);
  }

  Future<List<Movie>> _fetchPage({bool reset = false, String? genreId}) async {
    final api = ref.read(tmdbserviceProvider);
    final movies = await api.fetchNowPlaying(page: _page);
    if (reset) return movies;
    return [...?state.value, ...movies];
  }

  Future loadMore(String? genreId) async {
    if (!_hasMore) return;
    _page++;
    final newMovies = await _fetchPage(genreId: genreId);
    if (newMovies.isEmpty) _hasMore = false;
    state = AsyncData([...?state.value, ...newMovies]);
  }

  void refreshUI(String? genreId) async {
    _page = 1;
    _hasMore = true;
    state = const AsyncLoading();
    state = AsyncData(await _fetchPage(reset: true, genreId: genreId));
  }
}

final nowPlayingNotifierProvider =
    AsyncNotifierProvider.family<NowPlayingMovieNotifier, List<Movie>, String?>(
      (genreId) => NowPlayingMovieNotifier(),
    );
