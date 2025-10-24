import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_watch/data/tmdb_services.dart';
import 'package:movie_watch/models/cast.dart';
import 'package:movie_watch/models/movie_details.dart';
import 'package:movie_watch/models/movies.dart';

final tmdbserviceProvider = Provider<TmdbServices>((ref) => TmdbServices());

//popular movies
final popularMoviesProvider = FutureProvider<List<Movie>>((ref) {
  final services = ref.watch(tmdbserviceProvider);

  return services.fetchPopularMovies();
});

// movies genre
final movieGenreProvider = FutureProvider((ref) {
  final services = ref.watch(tmdbserviceProvider);

  return services.fetchMovieGenre();
});

// trendig movies
final trendingMoviesProvider = FutureProvider<List<Movie>>((ref) {
  final services = ref.watch(tmdbserviceProvider);

  return services.fetchTrendingMovies();
});

final movieDetailsProvider = FutureProvider.family<MovieDetails, int>((
  ref,
  movieId,
) {
  final services = ref.watch(tmdbserviceProvider);

  return services.fetchMovieDetails(movieId);
});
final movieCastProvider = FutureProvider.family<Cast, int>((ref, movieId) {
  final service = ref.watch(tmdbserviceProvider);
  return service.fetchMovieCast(movieId);
});
final nowPlayingProvider = FutureProvider<List<Movie>>((ref) {
  final service = ref.watch(tmdbserviceProvider);
  return service.fetchNowPlaying();
});
final upComingMovies = FutureProvider((ref) {
  final service = ref.watch(tmdbserviceProvider);
  return service.fetchUpcomingMovies();
});

final topRatedMovies = FutureProvider((ref) {
  final service = ref.watch(tmdbserviceProvider);
  return service.fetchTopRated();
});

///series
///
///
///
///
final popularSeriesProvider = FutureProvider<List<Movie>>((ref) {
  final services = ref.watch(tmdbserviceProvider);

  return services.fetchPopularSeries();
});
//series genre
final seriesGenreProvider = FutureProvider((ref) {
  final services = ref.watch(tmdbserviceProvider);

  return services.fetchSeriesGenre();
});
final airingTodayProvider = FutureProvider((ref) {
  final services = ref.watch(tmdbserviceProvider);

  return services.fetchAiringToday();
});
