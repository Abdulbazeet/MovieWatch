import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_watch/data/tmdb_services.dart';
import 'package:movie_watch/models/movies.dart';

final tmdbserviceProvider = Provider<TmdbServices>((ref) => TmdbServices());

final popularMoviesProvider = FutureProvider<List<Movies>>((ref) {
  final services = ref.watch(tmdbserviceProvider);

  return services.fetchPopularMovies();
});
final genreProvider = FutureProvider((ref) {
  final services = ref.watch(tmdbserviceProvider);

  return services.fetchGenre();
});
