// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Movie {
  final int id;
  final String? title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final String originalLanguage;
  final List<int> genreIds;
  final double voteAverage;
  final int voteCount;
  final double popularity;
  final bool adult;

  Movie({
    required this.id,
    this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    required this.originalLanguage,
    required this.genreIds,
    required this.voteAverage,
    required this.voteCount,
    required this.popularity,
    required this.adult,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? json['name'], // handle TV/trending too
      overview: json['overview'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      releaseDate: json['release_date'] ?? json['first_air_date'],
      originalLanguage: json['original_language'] ?? '',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      popularity: (json['popularity'] ?? 0).toDouble(),
      adult: json['adult'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'overview': overview,
      'posterPath': posterPath,
      'backdropPath': backdropPath,
      'releaseDate': releaseDate,
      'originalLanguage': originalLanguage,
      'genreIds': genreIds,
      'voteAverage': voteAverage,
      'voteCount': voteCount,
      'popularity': popularity,
      'adult': adult,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'] as int,
      title: map['title'] != null ? map['title'] as String : null,
      overview: map['overview'] != null ? map['overview'] as String : null,
      posterPath: map['posterPath'] != null
          ? map['posterPath'] as String
          : null,
      backdropPath: map['backdropPath'] != null
          ? map['backdropPath'] as String
          : null,
      releaseDate: map['releaseDate'] != null
          ? map['releaseDate'] as String
          : null,
      originalLanguage: map['originalLanguage'] as String,
      genreIds: List<int>.from((map['genreIds'] as List<int>)),
      voteAverage: map['voteAverage'] as double,
      voteCount: map['voteCount'] as int,
      popularity: map['popularity'] as double,
      adult: map['adult'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Movie.fromNewJson(String source) =>
      Movie.fromMap(json.decode(source) as Map<String, dynamic>);
}
