import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_watch/config/enums.dart';
import 'package:movie_watch/data/operations_services.dart';
import 'package:movie_watch/data/tmdb_services.dart';
import 'package:movie_watch/models/movie/credits.dart';
import 'package:movie_watch/models/series/episodes.dart';
import 'package:movie_watch/models/movie/movie_details.dart';
import 'package:movie_watch/models/movie/movies.dart';
import 'package:movie_watch/models/series/recommendations.dart';
import 'package:movie_watch/models/series/tvseries_credit.dart';
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
typedef episoeDetailsParams = ({
  int seriesId,
  int episodeNumber,
  int seasonNumber,
});
final episodeDetailsProvider =
    FutureProvider.family<Episodes, episoeDetailsParams>((ref, param) {
    return ref
        .watch(tmdbserviceProvider)
        .fetchEpisodeDetails(
          seriesId: param.seriesId,
          episode_number: param.episodeNumber,
          season_number: param.seasonNumber,
        );
  });
final seenProvider = FutureProvider.family<List<Movie>, MediaType>((
  ref,
  mediaType,
) {
  final service =  ref.watch(operationsServicesProvider);
  return service.seenList(mediaType);
});
