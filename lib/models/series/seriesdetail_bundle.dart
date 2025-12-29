// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:movie_watch/models/series/recommendations.dart';
import 'package:movie_watch/models/series/series_trailer.dart';
import 'package:movie_watch/models/series/show_details.dart';
import 'package:movie_watch/models/series/tvseries_credit.dart';

class TVSeriesBundle {
  final List<TvSeriesCredits> tvseriesCredit;
  final TvShow tvshwDetails;
  final SeriesTrailers seriesTrailers;
  final RecommendedSeries recommendedSeries;

  TVSeriesBundle({
    required this.tvseriesCredit,
    required this.tvshwDetails,
    required this.seriesTrailers,
    required this.recommendedSeries,
  });

  factory TVSeriesBundle.fromMap(Map<String, dynamic> map) {
    return TVSeriesBundle(
      tvseriesCredit: List<TvSeriesCredits>.from(
        (map['tvseriesCredit'] as List).map((x) => TvSeriesCredits.fromMap(x)),
      ),
      tvshwDetails: TvShow.fromMap(map['tvshwDetails'] as Map<String, dynamic>),
      seriesTrailers: SeriesTrailers.fromMap(
        map['seriesTrailers'] as Map<String, dynamic>,
      ),
      recommendedSeries: RecommendedSeries.fromMap(
        map['recommendedSeries'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tvseriesCredit': tvseriesCredit.map((x) => x.toMap()).toList(),
      'tvshwDetails': tvshwDetails.toMap(),
      'seriesTrailers': seriesTrailers.toMap(),
      'recommendedSeries': recommendedSeries.toMap(),
    };
  }

  String toJson() => json.encode(toMap());

  factory TVSeriesBundle.fromJson(String source) =>
      TVSeriesBundle.fromMap(json.decode(source) as Map<String, dynamic>);
}
