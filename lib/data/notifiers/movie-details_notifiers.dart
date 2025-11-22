import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_watch/data/movie_list_notifiers.dart';
import 'package:movie_watch/data/tmdb_providers.dart';
import 'package:movie_watch/models/credits.dart';
import 'package:movie_watch/models/movie_bundle.dart';
import 'package:movie_watch/models/movie_details.dart';
import 'package:movie_watch/models/movies.dart';
import 'package:movie_watch/models/recommendations.dart';
import 'package:movie_watch/models/videos.dart';

class MovieDetailsNotifiers extends AsyncNotifier<MovieBundle> {
  late int movieId;
  @override
  Future<MovieBundle> build() {
    return fetchDetails(movieId);
  }

  Future<MovieBundle> fetchDetails(int movieId) async {
    final api = ref.read(tmdbserviceProvider);
    final details = await Future.wait([
      api.fetchMovieDetails(movieId),
      api.fetchMovieCredits(movieId),

      api.fetchMovieRecommendations(movieId),
      api.fetchMovieVideos(movieId),
    ]);
    final movieDetails = MovieBundle(
      credits: details[1] as Credits,
      movieDetails: details[0] as MovieDetails,
      recommendations: details[2] as List<Movie>,
      video: details[3] as Videos,
    );
    return movieDetails;
  }
}

final movieDetailsNotifierProvider =
    AsyncNotifierProvider.family<MovieDetailsNotifiers, MovieBundle, int>((
      args,
    ) {
      return MovieDetailsNotifiers()..movieId = args;
    });
