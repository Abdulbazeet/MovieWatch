// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

class RecommendedSeries {
  final int page;
  final List<TvSeries> results;
  final int totalPages;
  final int totalResults;

  RecommendedSeries({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory RecommendedSeries.fromMap(Map<String, dynamic> map) =>
      RecommendedSeries(
        page: map['page'] ?? 1,
        results: (map['results'] as List<dynamic>)
            .map((e) => TvSeries.fromMap(e))
            .toList(),
        totalPages: map['total_pages'] ?? 0,
        totalResults: map['total_results'] ?? 0,
      );

  Map<String, dynamic> toMap() => {
    'page': page,
    'results': results.map((e) => e.toMap()).toList(),
    'total_pages': totalPages,
    'total_results': totalResults,
  };
}

class TvSeries {
  final bool adult;
  final String backdropPath;
  final int id;
  final String name;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final String posterPath;
  final String mediaType;
  final List<int> genreIds;
  final double popularity;
  final String firstAirDate;
  final double voteAverage;
  final int voteCount;
  final List<String> originCountry;

  TvSeries({
    required this.adult,
    required this.backdropPath,
    required this.id,
    required this.name,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.posterPath,
    required this.mediaType,
    required this.genreIds,
    required this.popularity,
    required this.firstAirDate,
    required this.voteAverage,
    required this.voteCount,
    required this.originCountry,
  });

  factory TvSeries.fromMap(Map<String, dynamic> map) => TvSeries(
    adult: map['adult'] ?? false,
    backdropPath: map['backdrop_path'] ?? '',
    id: map['id'],
    name: map['name'] ?? '',
    originalLanguage: map['original_language'] ?? '',
    originalName: map['original_name'] ?? '',
    overview: map['overview'] ?? '',
    posterPath: map['poster_path'] ?? '',
    mediaType: map['media_type'] ?? '',
    genreIds: List<int>.from(map['genre_ids'] ?? []),
    popularity: (map['popularity'] ?? 0).toDouble(),
    firstAirDate: map['first_air_date'] ?? '',
    voteAverage: (map['vote_average'] ?? 0).toDouble(),
    voteCount: map['vote_count'] ?? 0,
    originCountry: List<String>.from(map['origin_country'] ?? []),
  );

  Map<String, dynamic> toMap() => {
    'adult': adult,
    'backdrop_path': backdropPath,
    'id': id,
    'name': name,
    'original_language': originalLanguage,
    'original_name': originalName,
    'overview': overview,
    'poster_path': posterPath,
    'media_type': mediaType,
    'genre_ids': genreIds,
    'popularity': popularity,
    'first_air_date': firstAirDate,
    'vote_average': voteAverage,
    'vote_count': voteCount,
    'origin_country': originCountry,
  };

  static List<TvSeries> listFromMap(List<dynamic> list) =>
      list.map((e) => TvSeries.fromMap(e)).toList();
}
