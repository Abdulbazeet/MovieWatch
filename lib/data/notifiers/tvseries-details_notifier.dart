import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_watch/data/tmdb_providers.dart';
import 'package:movie_watch/models/recommendations.dart';
import 'package:movie_watch/models/series_trailer.dart';
import 'package:movie_watch/models/seriesdetail_bundle.dart';
import 'package:movie_watch/models/show_details.dart';
import 'package:movie_watch/models/tvseries_credit.dart';

class TvSeriesDetailsNotifier extends AsyncNotifier<TVSeriesBundle> {
  late int seriesId;
  @override
  Future<TVSeriesBundle> build() {
    return fetchDetails(seriesId);
  }

  Future<TVSeriesBundle> fetchDetails(int seriesId) async {
    final api = ref.read(tmdbserviceProvider);
    final details = await Future.wait([
      api.fetchTvSeriesDetails(seriesId: seriesId),

      api.fetchRecommendedTvSeries(seriesId: seriesId),
      api.fetchTvSeriesTrailers(seriesId: seriesId),
      api.fetchTvSeriesCredit(seriesId: seriesId),
    ]);
    final seriesDetails = TVSeriesBundle(
      tvshwDetails: details[0] as TvShow,
      recommendedSeries: details[1] as RecommendedSeries,
      seriesTrailers: details[2] as SeriesTrailers,

      tvseriesCredit: details[3] as List<TvSeriesCredits>,
    );
    return seriesDetails;
  }
}

final tvseriesDetailsNotifierProvider =
    AsyncNotifierProvider.family<TvSeriesDetailsNotifier, TVSeriesBundle, int>((
      arg,
    ) {
      return TvSeriesDetailsNotifier()..seriesId = arg;
    });
