// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PersonDetails {
  String? biography;
  String?  birthday;
  String? deathday;
  int? gender;
  int id;
  String? name;
  String? place_of_birth;
  String? profile_path;
  String? known_for_department;
  PersonDetails({
    required this.biography,
    required this.birthday,
    this.deathday,
    required this.gender,
    required this.id,
    required this.name,
    required this.place_of_birth,
    required this.profile_path,
    this.known_for_department,
  });

  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'biography': biography,
      'birthday': birthday,
      'deathday': deathday,
      'gender': gender,
      'id': id,
      'name': name,
      'place_of_birth': place_of_birth,
      'profile_path': profile_path,
      'known_for_department': known_for_department,
    };
  }

  factory PersonDetails.fromMap(Map<String, dynamic> map) {
    return PersonDetails(
      biography: map['biography'] != null ? map['biography'] as String : null,
      birthday: map['birthday'] != null ? map['birthday'] as String : null,
      deathday: map['deathday'] != null ? map['deathday'] as String : null,
      gender: map['gender'] != null ? map['gender'] as int : null,
      id: map['id'] as int,
      name: map['name'] != null ? map['name'] as String : null,
      place_of_birth: map['place_of_birth'] != null ? map['place_of_birth'] as String : null,
      profile_path: map['profile_path'] != null ? map['profile_path'] as String : null,
      known_for_department: map['known_for_department'] != null ? map['known_for_department'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PersonDetails.fromJson(String source) => PersonDetails.fromMap(json.decode(source) as Map<String, dynamic>);
}
