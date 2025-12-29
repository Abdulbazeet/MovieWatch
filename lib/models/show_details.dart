import 'dart:convert';

import 'package:movie_watch/models/genre.dart';

class TvShow {
  final bool adult;
  final String? backdropPath;
  final List<CreatedBy> createdBy;
  final dynamic episodeRunTime;
  final String firstAirDate;
  final List<Genres> genres;
  final String homepage;
  final int id;
  final bool inProduction;
  final List<String> languages;
  final String lastAirDate;
  final Episode? lastEpisodeToAir;
  final String name;
  final Episode? nextEpisodeToAir;
  final List<Network> networks;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final List<String> originCountry;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String posterPath;
  final List<ProductionCompany> productionCompanies;
  final List<ProductionCountry> productionCountries;
  final List<Season> seasons;
  final List<SpokenLanguage> spokenLanguages;
  final String status;
  final String tagline;
  final String type;
  final double voteAverage;
  final int voteCount;

  TvShow({
    required this.adult,
    required this.backdropPath,
    required this.createdBy,
    required this.episodeRunTime,
    required this.firstAirDate,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.inProduction,
    required this.languages,
    required this.lastAirDate,
    required this.lastEpisodeToAir,
    required this.name,
    required this.nextEpisodeToAir,
    required this.networks,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.productionCompanies,
    required this.productionCountries,
    required this.seasons,
    required this.spokenLanguages,
    required this.status,
    required this.tagline,
    required this.type,
    required this.voteAverage,
    required this.voteCount,
  });

  factory TvShow.fromMap(Map<String, dynamic> map) {
    return TvShow(
      adult: map['adult'] ?? false,
      backdropPath: map['backdrop_path'],
      createdBy: map['created_by'] == null
          ? []
          : List<CreatedBy>.from(
              map['created_by'].map((x) => CreatedBy.fromMap(x)),
            ),
      episodeRunTime: map['episode_run_time'],
      
      //  == []
      //     ? 0
      //     : map['episode_run_time'],
      firstAirDate: map['first_air_date'] ?? '',
      genres: map['genres'] == null
          ? []
          : List<Genres>.from(map['genres'].map((x) => Genres.fromMap(x))),
      homepage: map['homepage'] ?? '',
      id: map['id'] ?? 0,
      inProduction: map['in_production'] ?? false,
      languages: map['languages'] == null
          ? []
          : List<String>.from(map['languages']),
      lastAirDate: map['last_air_date'] ?? '',
      lastEpisodeToAir: map['last_episode_to_air'] == null
          ? null
          : Episode.fromMap(map['last_episode_to_air']),
      name: map['name'] ?? '',
      nextEpisodeToAir: map['next_episode_to_air'] == null
          ? null
          : Episode.fromMap(map['next_episode_to_air']),
      networks: map['networks'] == null
          ? []
          : List<Network>.from(map['networks'].map((x) => Network.fromMap(x))),
      numberOfEpisodes: map['number_of_episodes'] ?? 0,
      numberOfSeasons: map['number_of_seasons'] ?? 0,
      originCountry: map['origin_country'] == null
          ? []
          : List<String>.from(map['origin_country']),
      originalLanguage: map['original_language'] ?? '',
      originalName: map['original_name'] ?? '',
      overview: map['overview'] ?? '',
      popularity: (map['popularity'] ?? 0).toDouble(),
      posterPath: map['poster_path'] ?? '',
      productionCompanies: map['production_companies'] == null
          ? []
          : List<ProductionCompany>.from(
              map['production_companies'].map(
                (x) => ProductionCompany.fromMap(x),
              ),
            ),
      productionCountries: map['production_countries'] == null
          ? []
          : List<ProductionCountry>.from(
              map['production_countries'].map(
                (x) => ProductionCountry.fromMap(x),
              ),
            ),
      seasons: map['seasons'] == null
          ? []
          : List<Season>.from(map['seasons'].map((x) => Season.fromMap(x))),
      spokenLanguages: map['spoken_languages'] == null
          ? []
          : List<SpokenLanguage>.from(
              map['spoken_languages'].map((x) => SpokenLanguage.fromMap(x)),
            ),
      status: map['status'] ?? '',
      tagline: map['tagline'] ?? '',
      type: map['type'] ?? '',
      voteAverage: (map['vote_average'] ?? 0).toDouble(),
      voteCount: map['vote_count'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'adult': adult,
      'backdrop_path': backdropPath,
      'created_by': createdBy.map((x) => x.toMap()).toList(),
      'episode_run_time': episodeRunTime,
      'first_air_date': firstAirDate,
      'genres': genres.map((x) => x.toMap()).toList(),
      'homepage': homepage,
      'id': id,
      'in_production': inProduction,
      'languages': languages,
      'last_air_date': lastAirDate,
      'last_episode_to_air': lastEpisodeToAir?.toMap(),
      'name': name,
      'next_episode_to_air': nextEpisodeToAir,
      'networks': networks.map((x) => x.toMap()).toList(),
      'number_of_episodes': numberOfEpisodes,
      'number_of_seasons': numberOfSeasons,
      'origin_country': originCountry,
      'original_language': originalLanguage,
      'original_name': originalName,
      'overview': overview,
      'popularity': popularity,
      'poster_path': posterPath,
      'production_companies': productionCompanies
          .map((x) => x.toMap())
          .toList(),
      'production_countries': productionCountries
          .map((x) => x.toMap())
          .toList(),
      'seasons': seasons.map((x) => x.toMap()).toList(),
      'spoken_languages': spokenLanguages.map((x) => x.toMap()).toList(),
      'status': status,
      'tagline': tagline,
      'type': type,
      'vote_average': voteAverage,
      'vote_count': voteCount,
    };
  }

  factory TvShow.fromJson(String source) => TvShow.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}

class CreatedBy {
  final int id;
  final String creditId;
  final String name;
  final int gender;
  final String? profilePath;

  CreatedBy({
    required this.id,
    required this.creditId,
    required this.name,
    required this.gender,
    required this.profilePath,
  });

  factory CreatedBy.fromMap(Map<String, dynamic> map) {
    return CreatedBy(
      id: map['id'] ?? 0,
      creditId: map['credit_id'] ?? '',
      name: map['name'] ?? '',
      gender: map['gender'] ?? 0,
      profilePath: map['profile_path'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'credit_id': creditId,
      'name': name,
      'gender': gender,
      'profile_path': profilePath,
    };
  }
}

class Episode {
  final int id;
  final String name;
  final String overview;
  final double voteAverage;
  final int voteCount;
  final String airDate;
  final int episodeNumber;
  final String productionCode;
  final int runtime;
  final int seasonNumber;
  final int showId;
  final String? stillPath;

  Episode({
    required this.id,
    required this.name,
    required this.overview,
    required this.voteAverage,
    required this.voteCount,
    required this.airDate,
    required this.episodeNumber,
    required this.productionCode,
    required this.runtime,
    required this.seasonNumber,
    required this.showId,
    required this.stillPath,
  });

  factory Episode.fromMap(Map<String, dynamic> map) {
    return Episode(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      overview: map['overview'] ?? '',
      voteAverage: (map['vote_average'] ?? 0).toDouble(),
      voteCount: map['vote_count'] ?? 0,
      airDate: map['air_date'] ?? '',
      episodeNumber: map['episode_number'] ?? 0,
      productionCode: map['production_code'] ?? '',
      runtime: map['runtime'] ?? 0,
      seasonNumber: map['season_number'] ?? 0,
      showId: map['show_id'] ?? 0,
      stillPath: map['still_path'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'overview': overview,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'air_date': airDate,
      'episode_number': episodeNumber,
      'production_code': productionCode,
      'runtime': runtime,
      'season_number': seasonNumber,
      'show_id': showId,
      'still_path': stillPath,
    };
  }
}

class Network {
  final int id;
  final String? logoPath;
  final String name;
  final String originCountry;

  Network({
    required this.id,
    required this.logoPath,
    required this.name,
    required this.originCountry,
  });

  factory Network.fromMap(Map<String, dynamic> map) {
    return Network(
      id: map['id'] ?? 0,
      logoPath: map['logo_path'],
      name: map['name'] ?? '',
      originCountry: map['origin_country'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'logo_path': logoPath,
    'name': name,
    'origin_country': originCountry,
  };
}

class ProductionCompany {
  final int id;
  final String? logoPath;
  final String name;
  final String originCountry;

  ProductionCompany({
    required this.id,
    required this.logoPath,
    required this.name,
    required this.originCountry,
  });

  factory ProductionCompany.fromMap(Map<String, dynamic> map) {
    return ProductionCompany(
      id: map['id'] ?? 0,
      logoPath: map['logo_path'],
      name: map['name'] ?? '',
      originCountry: map['origin_country'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'logo_path': logoPath,
    'name': name,
    'origin_country': originCountry,
  };
}

class ProductionCountry {
  final String iso31661;
  final String name;

  ProductionCountry({required this.iso31661, required this.name});

  factory ProductionCountry.fromMap(Map<String, dynamic> map) {
    return ProductionCountry(
      iso31661: map['iso_3166_1'] ?? '',
      name: map['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {'iso_3166_1': iso31661, 'name': name};
}

class Season {
  final String airDate;
  final int episodeCount;
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final int seasonNumber;
  final double voteAverage;

  Season({
    required this.airDate,
    required this.episodeCount,
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.seasonNumber,
    required this.voteAverage,
  });

  factory Season.fromMap(Map<String, dynamic> map) {
    return Season(
      airDate: map['air_date'] ?? '',
      episodeCount: map['episode_count'] ?? 0,
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      overview: map['overview'] ?? '',
      posterPath: map['poster_path'],
      seasonNumber: map['season_number'] ?? 0,
      voteAverage: (map['vote_average'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'air_date': airDate,
      'episode_count': episodeCount,
      'id': id,
      'name': name,
      'overview': overview,
      'poster_path': posterPath,
      'season_number': seasonNumber,
      'vote_average': voteAverage,
    };
  }
}

class SpokenLanguage {
  final String englishName;
  final String iso6391;
  final String name;

  SpokenLanguage({
    required this.englishName,
    required this.iso6391,
    required this.name,
  });

  factory SpokenLanguage.fromMap(Map<String, dynamic> map) {
    return SpokenLanguage(
      englishName: map['english_name'] ?? '',
      iso6391: map['iso_639_1'] ?? '',
      name: map['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'english_name': englishName,
    'iso_639_1': iso6391,
    'name': name,
  };
}
