// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class SearchResults {
  final int id;
  final String media_type;
  final bool? adult;
  final String? backdrop_path;
  final String? name;
  final String? poster_path;
  final String? first_air_date;
  final double? vote_average;
  final String? known_for_department;
  final String? profile_path;
  final List<KnownFor>? known_for;
  SearchResults({
    required this.id,
    required this.media_type,
    required this.adult,
    required this.backdrop_path,
    required this.name,
    required this.poster_path,
    required this.first_air_date,
    required this.vote_average,
    required this.known_for_department,
    required this.profile_path,
    required this.known_for,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'media_type': media_type,
      'adult': adult,
      'backdrop_path': backdrop_path,
      'name': name,
      'poster_path': poster_path,
      'first_air_date': first_air_date,
      'vote_average': vote_average,
      'known_for_department': known_for_department,
      'profile_path': profile_path,
      'known_for': known_for?.map((x) => x.toMap()).toList(),
    };
  }

  factory SearchResults.fromMap(Map<String, dynamic> map) {
    return SearchResults(
      id: map['id'] as int,
      media_type: map['media_type'] as String,
      adult: map['adult'] as bool,
      backdrop_path: map['backdrop_path'] != null
          ? map['backdrop_path'] as String
          : null,
      name: map['name'] ?? map['title'],
      poster_path: map['poster_path'] != null
          ? map['poster_path'] as String
          : null,
      first_air_date: map['first_air_date'] ?? map['release_date'] ,
      vote_average: map['vote_average'] != null
          ? map['vote_average'] as double
          : null,
      known_for_department: map['known_for_department'] != null
          ? map['known_for_department'] as String
          : null,
      profile_path: map['profile_path'] != null
          ? map['profile_path'] as String
          : null,
      known_for: map['known_for'] != null
          ? List<KnownFor>.from(
              (map['known_for']).map((x) => KnownFor.fromMap(x)),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchResults.fromJson(String source) =>
      SearchResults.fromMap(json.decode(source) as Map<String, dynamic>);
}

class KnownFor {
  final String? title;
  KnownFor({required this.title});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'title': title};
  }

  factory KnownFor.fromMap(Map<String, dynamic> map) {
    return KnownFor(title: map['title'] ?? map['name']);
  }

  String toJson() => json.encode(toMap());

  factory KnownFor.fromJson(String source) =>
      KnownFor.fromMap(json.decode(source) as Map<String, dynamic>);
}
