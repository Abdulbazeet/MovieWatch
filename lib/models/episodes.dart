// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Episodes {
  final String air_date;
  final List<EpisodeCrew> crew;

  final int episode_number;
  final List<GuestStars> guest_stars;
  final String name;
  final String overview;
  final int id;
  final String production_code;
  final int runtime;

  final int season_number;
  final String still_path;
  final double vote_average;
  final int vote_count;
  Episodes({
    required this.air_date,
    required this.crew,
    required this.episode_number,
    required this.guest_stars,
    required this.name,
    required this.overview,
    required this.id,
    required this.production_code,
    required this.runtime,
    required this.season_number,
    required this.still_path,
    required this.vote_average,
    required this.vote_count,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'air_date': air_date,
      'crew': crew.map((x) => x.toMap()).toList(),
      'episode_number': episode_number,
      'guest_stars': guest_stars.map((x) => x.toMap()).toList(),
      'name': name,
      'overview': overview,
      'id': id,
      'production_code': production_code,
      'runtime': runtime,
      'season_number': season_number,
      'still_path': still_path,
      'vote_average': vote_average,
      'vote_count': vote_count,
    };
  }

  factory Episodes.fromMap(Map<String, dynamic> map) {
    return Episodes(
      air_date: map['air_date'] ?? '',
      crew: List<EpisodeCrew>.from(
        (map['crew'] as List).map((x) => EpisodeCrew.fromMap(x)),
      ),
      episode_number: map['episode_number'] ?? 0,
      guest_stars: List<GuestStars>.from(
        (map['guest_stars'] as List).map((x) => GuestStars.fromMap(x)),
      ),
      name: map['name'] ?? '',
      overview: map['overview'] ?? '',
      id: map['id'] ?? 0,
      production_code: map['production_code'] ?? '',
      runtime: map['runtime'] ?? 0,
      season_number: map['season_number'] ?? 0,
      still_path: map['still_path'] ?? '',
      vote_average: map['vote_average'] ?? 0.0,
      vote_count: map['vote_count'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Episodes.fromJson(String source) =>
      Episodes.fromMap(json.decode(source) as Map<String, dynamic>);
}

class EpisodeCrew {
  final String department;
  final String job;
  final String credit_id;
  final bool adult;
  final int gender;
  final int id;
  final String known_for_department;
  final String name;
  final double popularity;
  final String profile_path;
  EpisodeCrew({
    required this.department,
    required this.job,
    required this.credit_id,
    required this.adult,
    required this.gender,
    required this.id,
    required this.known_for_department,
    required this.name,
    required this.popularity,
    required this.profile_path,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'department': department,
      'job': job,
      'credit_id': credit_id,
      'adult': adult,
      'gender': gender,
      'id': id,
      'known_for_department': known_for_department,
      'name': name,
      'popularity': popularity,
      'profile_path': profile_path,
    };
  }

  factory EpisodeCrew.fromMap(Map<String, dynamic> map) {
    return EpisodeCrew(
      department: map['department'] ?? '',
      job: map['job'] ?? '',
      credit_id: map['credit_id'] ?? '',
      adult: map['adult'] ?? false,
      gender: map['gender'] ?? 0,
      id: map['id'] ?? 0,
      known_for_department: map['known_for_department'] ?? '',
      name: map['name'] ?? '',
      popularity: map['popularity'] ?? 0.0,
      profile_path: map['profile_path'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory EpisodeCrew.fromJson(String source) =>
      EpisodeCrew.fromMap(json.decode(source) as Map<String, dynamic>);
}

class GuestStars {
  final String character;
  final String credit_id;
  final int order;
  final bool adult;
  final int id;
  final int gender;
  final String known_for_department;
  final String name;
  final double popularity;
  final String profile_path;
  GuestStars({
    required this.character,
    required this.credit_id,
    required this.order,
    required this.adult,
    required this.id,
    required this.gender,
    required this.known_for_department,
    required this.name,
    required this.popularity,
    required this.profile_path,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'character': character,
      'credit_id': credit_id,
      'order': order,
      'adult': adult,
      'id': id,
      'gender': gender,
      'known_for_department': known_for_department,
      'name': name,
      'popularity': popularity,
      'profile_path': profile_path,
    };
  }

  factory GuestStars.fromMap(Map<String, dynamic> map) {
    return GuestStars(
      character: map['character'] ?? '',
      credit_id: map['credit_id'] ?? '',
      order: map['order'] ?? 0,
      adult: map['adult'] ?? false,
      id: map['id'] ?? 0,
      gender: map['gender'] ?? 0,
      known_for_department: map['known_for_department'] ?? '',
      name: map['name'] ?? '',
      popularity: map['popularity'] ?? 0.0,
      profile_path: map['profile_path'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory GuestStars.fromJson(String source) =>
      GuestStars.fromMap(json.decode(source) as Map<String, dynamic>);
}
