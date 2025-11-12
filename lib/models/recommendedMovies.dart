import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Recommendations {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final String releaseDate;
  final String originalLanguage;
  final List<int> genreIds;
  final double voteAverage;
  final int voteCount;
  final double popularity;
  final bool adult;
  Recommendations({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.originalLanguage,
    required this.genreIds,
    required this.voteAverage,
    required this.voteCount,
    required this.popularity,
    required this.adult,
  });

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

  factory Recommendations.fromMap(Map<String, dynamic> map) {
    return Recommendations(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      overview: map['overview'] ?? '',
      posterPath: map['poster_path'] ?? '',
      backdropPath: map['backdrop_path'] ?? '',
      releaseDate: map['release_date'] ?? '',
      originalLanguage: map['original_language'] ?? '',
      genreIds: List<int>.from((map['genre_ids'] as List)),
      voteAverage: map['vote_average'] ?? 0.0,
      voteCount: map['vote_count'] ?? 0,
      popularity: map['popularity'] ?? 0.0,
      adult: map['adult'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Recommendations.fromJson(String source) =>
      Recommendations.fromMap(json.decode(source) as Map<String, dynamic>);
}
