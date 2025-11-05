// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:movie_watch/models/credits.dart';
import 'package:movie_watch/models/movie_details.dart';
import 'package:movie_watch/models/movies.dart';
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
      credits: Credits.fromMap(map['credits'] as Map<String, dynamic>),
      movieDetails: MovieDetails.fromMap(
        map['movieDetails'] as Map<String, dynamic>,
      ),
      recommendations: List<Movie>.from(
        (map['recommendations'] as List<int>).map<Movie>(
          (x) => Movie.fromMap(x as Map<String, dynamic>),
        ),
      ),
      video: Videos.fromMap(map['video'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory MovieBundle.fromJson(String source) =>
      MovieBundle.fromMap(json.decode(source) as Map<String, dynamic>);
}
