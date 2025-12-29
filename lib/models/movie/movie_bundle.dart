// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:movie_watch/models/movie/credits.dart';
import 'package:movie_watch/models/movie/movie_details.dart';
import 'package:movie_watch/models/movie/movies.dart';
import 'package:movie_watch/models/series/recommendations.dart';
import 'package:movie_watch/models/videos.dart';

class MovieBundle {
  final Credits credits;
  final MovieDetails movieDetails;
  final List<Movie> recommendations;
  final Videos video;
  MovieBundle({
    required this.credits,
    required this.movieDetails,
    required this.recommendations,
    required this.video,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'credits': credits.toMap(),
      'movieDetails': movieDetails.toMap(),
      'recommendations': recommendations.map((x) => x.toMap()).toList(),
      'video': video.toMap(),
    };
  }

  factory MovieBundle.fromMap(Map<String, dynamic> map) {
    return MovieBundle(
      credits: Credits.fromMap(map['credits']),
      movieDetails: MovieDetails.fromMap(map['movieDetails']),
      recommendations: List<Movie>.from(
        (map['recommendations'] as List).map((x) => Movie.fromMap(x)),
      ),
      video: Videos.fromMap(map['video']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MovieBundle.fromJson(String source) =>
      MovieBundle.fromMap(json.decode(source) as Map<String, dynamic>);
}
