// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:movie_watch/models/recommendations.dart';
import 'package:movie_watch/models/series_trailer.dart';
import 'package:movie_watch/models/show_details.dart';
import 'package:movie_watch/models/tvseries_credit.dart';

class TVSeriesBundle {
  final TvSeriesCredits tvseriesCredit;
  final TvShow tvshwDetails;
  final SeriesTrailers seriesTrailers;
  final RecommendedSeries recommendedSeries;

  TVSeriesBundle({
    required this.tvseriesCredit,
    required this.tvshwDetails,
    required this.seriesTrailers,
    required this.recommendedSeries,
  });

  factory TVSeriesBundle.fromMap(Map<String, dynamic> map) => TVSeriesBundle(
    tvseriesCredit: TvSeriesCredits.fromMap(map['tvseriesCredit']),
    tvshwDetails: TvShow.fromMap(map['tvshwDetails']),
    seriesTrailers: SeriesTrailers.fromMap(map['seriesTrailers']),
    recommendedSeries: RecommendedSeries.fromMap(map['recommendedSeries']),
  );

  Map<String, dynamic> toMap() => {
    'tvseriesCredit': tvseriesCredit.toMap(),
    'tvshwDetails': tvshwDetails.toMap(),
    'seriesTrailers': seriesTrailers.toMap(),
    'recommendedSeries': recommendedSeries.toMap(),
  };
}
