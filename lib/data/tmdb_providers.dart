import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_watch/data/tmdb_services.dart';
import 'package:movie_watch/models/credits.dart';
import 'package:movie_watch/models/movie_details.dart';
import 'package:movie_watch/models/movies.dart';
import 'package:movie_watch/models/recommendations.dart';
import 'package:movie_watch/models/tvseries_credit.dart';
import 'package:movie_watch/models/videos.dart';

final tmdbserviceProvider = Provider<TmdbServices>((ref) => TmdbServices());

//popular movies
final popularMoviesProvider = FutureProvider<List<Movie>>((ref) {
  final services = ref.watch(tmdbserviceProvider);

  return services.fetchPopularMovies();
});

// movies genre
final movieGenreProvider = FutureProvider((ref) {
  final services = ref.watch(tmdbserviceProvider);
  ref.keepAlive();

  return services.fetchMovieGenre();
});

// trendig movies
final trendingMoviesProvider = FutureProvider<List<Movie>>((ref) {
  final services = ref.watch(tmdbserviceProvider);
  ref.keepAlive();

  return services.fetchTrendingMovies();
});

final nowPlayingProvider = FutureProvider<List<Movie>>((ref) {
  final service = ref.watch(tmdbserviceProvider);
  ref.keepAlive();

  return service.fetchNowPlaying();
});
final upComingMovies = FutureProvider((ref) {
  final service = ref.watch(tmdbserviceProvider);
  ref.keepAlive();

  return service.fetchUpcomingMovies();
});

final topRatedMovies = FutureProvider((ref) {
  final service = ref.watch(tmdbserviceProvider);
  ref.keepAlive();

  return service.fetchTopRated();
});

// final test = FutureProvider.family<List<Recommendations>, int>((ref, movieId) {
//   final api = ref.watch(tmdbserviceProvider).fetchMovieRecommendations(movieId);
//   return api;
// });

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
final newSeriesPovider = FutureProvider((ref) {
  final services = ref.watch(tmdbserviceProvider);

  return services.fetchNewSeries();
});
final trendingSeriesPovider = FutureProvider((ref) {
  final services = ref.watch(tmdbserviceProvider);

  return services.fetchTrendingSeries();
});
final upcomingSeriesPovider = FutureProvider((ref) {
  final services = ref.watch(tmdbserviceProvider);

  return services.fetchUpcomingSeries();
});
final topRatedSeriesPovider = FutureProvider((ref) {
  final services = ref.watch(tmdbserviceProvider);

  return services.fetchTopRatedSeries();
});

final test = FutureProvider.family<List<TvSeriesCredits>, int>((ref, param) {
  return ref.watch(tmdbserviceProvider).fetchTvSeriesCredit(seriesId: param);
});
