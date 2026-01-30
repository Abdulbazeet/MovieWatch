import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_watch/config/enums.dart';
import 'package:movie_watch/data/tmdb_providers.dart';
import 'package:movie_watch/models/movie/movies.dart';

class MovieListNotifier extends AsyncNotifier<List<Movie>> {
  int _page = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  late String? genreId;
  late MovieType movieType;
  late TableType tableType;

  // @override
  // FutureOr<List<Movie>> build(
  //   (MovieType movieType, TableType tableType) params,
  // ) async {
  //   final movieType = params.$1;
  //   final tableType = params.$2;
  //   return _fetchPage(reset: true, movieType: movieType, tableType: tableType);
  // }
  @override
  Future<List<Movie>> build() async {
    // Initial fetch
    return _fetchPage(
      movieType: movieType,
      tableType: tableType,
      genreId: genreId,
    );
  }

  Future<List<Movie>> _fetchPage({
    bool reset = false,
    String? genreId,
    required MovieType movieType,
    required TableType tableType,
  }) async {
    final movies = await switch (tableType) {
      TableType.movies => switch (movieType) {
        MovieType.nowPlaying =>
          ref
              .read(tmdbserviceProvider)
              .fetchNowPlaying(genreId: genreId, page: _page),
        MovieType.popular =>
          ref
              .read(tmdbserviceProvider)
              .fetchPopularMovies(genreId: genreId, page: _page),
        MovieType.topRated =>
          ref
              .read(tmdbserviceProvider)
              .fetchTopRated(genreId: genreId, page: _page),
        MovieType.trending =>
          ref
              .read(tmdbserviceProvider)
              .fetchUpcomingMovies(genreId: genreId, page: _page),
        MovieType.upcoming =>
          ref
              .read(tmdbserviceProvider)
              .fetchUpcomingMovies(genreId: genreId, page: _page),
        _ => null,
      },
      TableType.tvshows => switch (movieType) {
        MovieType.nowPlaying =>
          ref
              .read(tmdbserviceProvider)
              .fetchNewSeries(genreId: genreId, page: _page),
        MovieType.popular =>
          ref
              .read(tmdbserviceProvider)
              .fetchPopularSeries(genreId: genreId, page: _page),
        MovieType.topRated =>
          ref
              .read(tmdbserviceProvider)
              .fetchTopRatedSeries(genreId: genreId, page: _page),
        MovieType.trending =>
          ref
              .read(tmdbserviceProvider)
              .fetchTrendingSeries(genreId: genreId, page: _page),
        MovieType.upcoming =>
          ref
              .read(tmdbserviceProvider)
              .fetchUpcomingSeries(genreId: genreId, page: _page),
        MovieType.airingToday =>
          ref
              .read(tmdbserviceProvider)
              .fetchAiringToday(genreId: genreId, page: _page),
      },
      _ => null,
    };

    // final movies = await api.fetchNowPlaying(page: _page, genreId: genreId);
    return movies ?? [];
  }

  Future loadMore(
    String? genreId,
    MovieType movieType,
    TableType tableType,
  ) async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    _page++;
    final newMovies = await _fetchPage(
      genreId: genreId,
      movieType: movieType,
      tableType: tableType,
    );
    if (newMovies.isEmpty) _hasMore = false;
    state = AsyncData([...state.value ?? [], ...newMovies]);
    _isLoadingMore = false;
  }

  void refreshUI(
    String? genreId,
    MovieType movieType,
    TableType tableType,
  ) async {
    state = const AsyncLoading();
    _page = 1;
    _hasMore = true;
    _isLoadingMore = false;
    // state = const AsyncLoading()
    final movies = await _fetchPage(
      reset: true,
      genreId: genreId,
      movieType: movieType,
      tableType: tableType,
    );
    state = AsyncData(movies);
  }
}

final movieListNotifier =
    AsyncNotifierProvider.family<
      MovieListNotifier,
      List<Movie>,
      (String? genreId, MovieType movieType, TableType tableType)
    >(
      (arg) => MovieListNotifier()
        ..genreId = arg.$1
        ..movieType = arg.$2
        ..tableType = arg.$3,
    );
