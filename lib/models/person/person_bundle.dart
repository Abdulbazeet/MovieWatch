// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:movie_watch/models/person/person-credits.dart';
import 'package:movie_watch/models/person/person_details.dart';

class PersonBundle {
  final PersonDetails personDetails;
  final List<PersonCredits> personCredits;

  PersonBundle({required this.personDetails, required this.personCredits});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'personDetails': personDetails.toMap(),
      'personCredits': personCredits.map((x) => x.toMap()).toList(),
    };
  }

  factory PersonBundle.fromMap(Map<String, dynamic> map) {
    return PersonBundle(
      personDetails: PersonDetails.fromMap(
        map['personDetails'] as Map<String, dynamic>,
      ),
      personCredits: List<PersonCredits>.from(
        (map['personCredits']).map((x) => PersonCredits.fromMap(x)),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory PersonBundle.fromJson(String source) =>
      PersonBundle.fromMap(json.decode(source) as Map<String, dynamic>);
}
