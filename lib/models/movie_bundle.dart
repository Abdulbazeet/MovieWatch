// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:movie_watch/models/cast.dart';
import 'package:movie_watch/models/movie_details.dart';
import 'package:movie_watch/models/movies.dart';

class MovieBundle {
  final Cast cast;
  final MovieDetails movieDetails;
  final List<Movie> movie;
  MovieBundle({
    required this.cast,
    required this.movieDetails,
    required this.movie,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cast': cast.toMap(),
      'movieDetails': movieDetails.toMap(),
      'movie': movie.map((x) => x.toMap()).toList(),
    };
  }

  factory MovieBundle.fromMap(Map<String, dynamic> map) {
    return MovieBundle(
      cast: Cast.fromMap(map['cast'] as Map<String, dynamic>),
      movieDetails: MovieDetails.fromMap(
        map['movieDetails'] as Map<String, dynamic>,
      ),
      movie: List<Movie>.from(
        (map['movie'] as List<int>).map<Movie>(
          (x) => Movie.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory MovieBundle.fromJson(String source) =>
      MovieBundle.fromMap(json.decode(source) as Map<String, dynamic>);
}
