// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:movie_watch/models/genre.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class MovieDetails {
  final bool adult;
  final String? backdrop_path;
  final int budget;
  final List<Genres> genres;
  final String? homepage;
  final int id;
  final String? imdb_id;
  final String original_language;
  final String original_title;
  final String overview;
  final double popularity;
  final String? poster_path;
  final List<ProductionCompany> production_companies;
  final List<ProductionCoutries> production_countries;
  final String release_date;
  final int revenue;
  final int runtime;
  final List<SpokenLanguage> spoken_languages;
  final String status;
  final String? tagline;
  final String title;
  final bool video;
  final double vote_average;
  final int vote_count;
  MovieDetails({
    required this.adult,
    this.backdrop_path,
    required this.budget,
    required this.genres,
    this.homepage,
    required this.id,
    this.imdb_id,
    required this.original_language,
    required this.original_title,
    required this.overview,
    required this.popularity,
    this.poster_path,
    required this.production_companies,
    required this.production_countries,
    required this.release_date,
    required this.revenue,
    required this.runtime,
    required this.spoken_languages,
    required this.status,
    this.tagline,
    required this.title,
    required this.video,
    required this.vote_average,
    required this.vote_count,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'adult': adult,
      'backdrop_path': backdrop_path,
      'budget': budget,
      'genres': genres.map((x) => x.toMap()).toList(),
      'homepage': homepage,
      'id': id,
      'imdb_id': imdb_id,
      'original_language': original_language,
      'original_title': original_title,
      'overview': overview,
      'popularity': popularity,
      'poster_path': poster_path,
      'production_companies': production_companies
          .map((x) => x.toMap())
          .toList(),
      'production_countries': production_countries
          .map((x) => x.toMap())
          .toList(),
      'release_date': release_date,
      'revenue': revenue,
      'runtime': runtime,
      'spoken_languages': spoken_languages.map((x) => x.toMap()).toList(),
      'status': status,
      'tagline': tagline,
      'title': title,
      'video': video,
      'vote_average': vote_average,
      'vote_count': vote_count,
    };
  }

  factory MovieDetails.fromMap(Map<String, dynamic> map) {
    return MovieDetails(
      adult: map['adult'] as bool,
      backdrop_path: map['backdrop_path'] != null
          ? map['backdrop_path'] as
           String
          : null,
      budget: map['budget'] as int,
      genres: List<Genres>.from(
        (map['genres'] as List).map(
          (x) => Genres.fromMap(x as Map<String, dynamic>),
        ),
      ),
      homepage: map['homepage'] != null ? map['homepage'] as String : null,
      id: map['id'] as int,
      imdb_id: map['imdb_id'] != null ? map['imdb_id'] as String : null,
      original_language: map['original_language'] as String,
      original_title: map['original_title'] as String,
      overview: map['overview'] as String,
      popularity: map['popularity'] as double,
      poster_path: map['poster_path'] != null
          ? map['poster_path'] as String
          : null,
      production_companies: List<ProductionCompany>.from(
        (map['production_companies'] as List).map(
          (x) => ProductionCompany.fromMap(x as Map<String, dynamic>),
        ),
      ),
      production_countries: List<ProductionCoutries>.from(
        (map['production_countries'] as List).map(
          (x) => ProductionCoutries.fromMap(x as Map<String, dynamic>),
        ),
      ),
      release_date: map['release_date'] as String,
      revenue: map['revenue'] as int,
      runtime: map['runtime'] as int,
      spoken_languages: List<SpokenLanguage>.from(
        (map['spoken_languages'] as List).map(
          (x) => SpokenLanguage.fromMap(x as Map<String, dynamic>),
        ),
      ),
      status: map['status'] as String,
      tagline: map['tagline'] != null ? map['tagline'] as String : null,
      title: map['title'] as String,
      video: map['video'] as bool,
      vote_average: map['vote_average'] as double,
      vote_count: map['vote_count'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory MovieDetails.fromJson(String source) =>
      MovieDetails.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ProductionCompany {
  final int id;
  final String logo_path;
  final String name;
  final String origin_country;
  ProductionCompany({
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

  factory ProductionCompany.fromMap(Map<String, dynamic> map) {
    return ProductionCompany(
      id: map['id'] as int,
      logo_path: map['logo_path'] as String,
      name: map['name'] as String,
      origin_country: map['origin_country'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductionCompany.fromJson(String source) =>
      ProductionCompany.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ProductionCoutries {
  final String iso_3166_1;
  final String name;

  ProductionCoutries({required this.iso_3166_1, required this.name});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'iso_3166_1': iso_3166_1, 'name': name};
  }

  factory ProductionCoutries.fromMap(Map<String, dynamic> map) {
    return ProductionCoutries(
      iso_3166_1: map['iso_3166_1'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductionCoutries.fromJson(String source) =>
      ProductionCoutries.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SpokenLanguage {
  final String english_name;
  final String iso_639_1;
  final String name;
  SpokenLanguage({
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

  factory SpokenLanguage.fromMap(Map<String, dynamic> map) {
    return SpokenLanguage(
      english_name: map['english_name'] as String,
      iso_639_1: map['iso_639_1'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SpokenLanguage.fromJson(String source) =>
      SpokenLanguage.fromMap(json.decode(source) as Map<String, dynamic>);
}
