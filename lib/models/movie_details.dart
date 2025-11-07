// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:movie_watch/models/genre.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class MovieDetails {
  final bool adult;
  final String backdrop_path;
  final int budget;
  final String homepage;
  final int id;
  final String imdb_id;
  final String original_language;
  final String original_title;
  final String overview;
  final double popularity;
  final String poster_path;
  final String release_date;
  final int revenue;
  final String status;
  final String tagline;
  final String title;
  final bool video;
  final double vote_average;
  final int vote_count;
  final int runtime;

  final List<Genres> genres;
  final List<ProductionCompanies> production_companies;
  final List<ProductionCountries> production_countries;
  final List<SpokenLanguages> spoken_languages;
  MovieDetails({
    required this.adult,
    required this.backdrop_path,
    required this.budget,
    required this.homepage,
    required this.id,
    required this.imdb_id,
    required this.original_language,
    required this.original_title,
    required this.overview,
    required this.popularity,
    required this.poster_path,
    required this.release_date,
    required this.revenue,
    required this.status,
    required this.tagline,
    required this.title,
    required this.video,
    required this.vote_average,
    required this.vote_count,
    required this.runtime,
    required this.genres,
    required this.production_companies,
    required this.production_countries,
    required this.spoken_languages,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'adult': adult,
      'backdrop_path': backdrop_path,
      'budget': budget,
      'homepage': homepage,
      'id': id,
      'imdb_id': imdb_id,
      'original_language': original_language,
      'original_title': original_title,
      'overview': overview,
      'popularity': popularity,
      'poster_path': poster_path,
      'release_date': release_date,
      'revenue': revenue,
      'status': status,
      'tagline': tagline,
      'title': title,
      'video': video,
      'vote_average': vote_average,
      'vote_count': vote_count,
      'runtime': runtime,
      'genres': genres.map((x) => x.toMap()).toList(),
      'production_companies': production_companies
          .map((x) => x.toMap())
          .toList(),
      'production_countries': production_countries
          .map((x) => x.toMap())
          .toList(),
      'spoken_languages': spoken_languages.map((x) => x.toMap()).toList(),
    };
  }

  factory MovieDetails.fromMap(Map<String, dynamic> map) {
    return MovieDetails(
      adult: map['adult'] ?? false,
      backdrop_path: map['backdrop_path'] ?? '',
      budget: map['budget'] ?? 0,
      homepage: map['homepage'] ?? '',
      id: map['id'] ?? 0,
      imdb_id: map['imdb_id'] ?? '',
      original_language: map['original_language'] ?? '',
      original_title: map['original_title'] ?? '',
      overview: map['overview'] ?? '',
      popularity: map['popularity'] ?? 0.0,
      poster_path: map['poster_path'] ?? '',
      release_date: map['release_date'] ?? '',
      revenue: map['revenue'] ?? 0,
      status: map['status'] ?? '',
      tagline: map['tagline'] ?? '',
      title: map['title'] ?? '',
      video: map['video'] as bool,
      vote_average: map['vote_average'] ?? 0.0,
      vote_count: map['vote_count'] ?? 0,
      runtime: map['runtime'] ?? 0,
      genres: List<Genres>.from(
        (map['genres'] as List).map((x) => Genres.fromMap(x)),
      ),
      production_companies: List<ProductionCompanies>.from(
        (map['production_companies'] as List).map(
          (x) => ProductionCompanies.fromMap(x),
        ),
      ),
      production_countries: List<ProductionCountries>.from(
        (map['production_countries'] as List).map(
          (x) => ProductionCountries.fromMap(x),
        ),
      ),
      spoken_languages: List<SpokenLanguages>.from(
        (map['spoken_languages'] as List).map<SpokenLanguages>(
          (x) => SpokenLanguages.fromMap(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory MovieDetails.fromJson(String source) =>
      MovieDetails.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ProductionCompanies {
  final int id;
  final String logo_path;
  final String name;
  final String origin_country;
  ProductionCompanies({
    required this.id,
    required this.logo_path,
    required this.name,
    required this.origin_country,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'logo_path': logo_path,
      'name': name,
      'origin_country': origin_country,
    };
  }

  factory ProductionCompanies.fromMap(Map<String, dynamic> map) {
    return ProductionCompanies(
      id: map['id'] ?? 0,
      logo_path: map['logo_path'] ?? '',
      name: map['name'] ?? '',
      origin_country: map['origin_country'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductionCompanies.fromJson(String source) =>
      ProductionCompanies.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ProductionCountries {
  final String iso_3166_1;
  final String name;
  ProductionCountries({required this.iso_3166_1, required this.name});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'iso_3166_1': iso_3166_1, 'name': name};
  }

  factory ProductionCountries.fromMap(Map<String, dynamic> map) {
    return ProductionCountries(
      iso_3166_1: map['iso_3166_1'] ?? '',
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductionCountries.fromJson(String source) =>
      ProductionCountries.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SpokenLanguages {
  final String english_name;
  final String iso_639_1;
  final String name;
  SpokenLanguages({
    required this.english_name,
    required this.iso_639_1,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'english_name': english_name,
      'iso_639_1': iso_639_1,
      'name': name,
    };
  }

  factory SpokenLanguages.fromMap(Map<String, dynamic> map) {
    return SpokenLanguages(
      english_name: map['english_name'] ?? '',
      iso_639_1: map['iso_639_1'] ?? '',
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SpokenLanguages.fromJson(String source) =>
      SpokenLanguages.fromMap(json.decode(source) as Map<String, dynamic>);
}
