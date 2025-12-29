import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
class PersonCredits {
  bool adult;
  int id;
  String? backdrop_path;
  String? title;
  String? overview;
  double? vote_average;
  String media_type;
  String? character;
  String? credit_id;
  String? release_date;
  String? poster_path;
  double? popularity;
  PersonCredits({
    required this.adult,
    required this.id,
    this.backdrop_path,
    this.title,
    this.overview,
    this.vote_average,
    required this.media_type,
    this.character,
    this.credit_id,
    this.release_date,
    this.poster_path,
    this.popularity,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'adult': adult,
      'id': id,
      'backdrop_path': backdrop_path,
      'title': title,
      'overview': overview,
      'vote_average': vote_average,
      'media_type': media_type,
      'character': character,
      'credit_id': credit_id,
      'release_date': release_date,
      'poster_path': poster_path,
      'popularity': popularity,
    };
  }

  factory PersonCredits.fromMap(Map<String, dynamic> map) {
    return PersonCredits(
      adult: map['adult'] as bool,
      id: map['id'] as int,
      backdrop_path: map['backdrop_path'] != null
          ? map['backdrop_path'] as String
          : null,
      title: map['title'] ?? map['name'],
      overview: map['overview'] != null ? map['overview'] as String : null,
      vote_average: map['vote_average'] != null
          ? map['vote_average'] as double
          : null,
      media_type: map['media_type'] as String,
      character: map['character'] != null ? map['character'] as String : null,
      credit_id: map['credit_id'] != null ? map['credit_id'] as String : null,
      release_date: map['release_date'] != null
          ? map['release_date'] as String
          : null,
      poster_path: map['poster_path'] != null
          ? map['poster_path'] as String
          : null,
      popularity: map['popularity'] != null
          ? map['popularity'] as double
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PersonCredits.fromJson(String source) =>
      PersonCredits.fromMap(json.decode(source) as Map<String, dynamic>);
}
