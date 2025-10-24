import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Genres {
  final int id;
  final String name;
  Genres({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory Genres.fromMap(Map<String, dynamic> map) {
    return Genres(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Genres.fromJson(String source) => Genres.fromMap(json.decode(source) as Map<String, dynamic>);
}
