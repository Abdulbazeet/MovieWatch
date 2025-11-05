import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Cast {
  final int id;
  final String name;
  final String character;
  final String? profilePath;
  final double popularity;
  final int order;
  Cast({
    required this.id,
    required this.name,
    required this.character,
    this.profilePath,
    required this.popularity,
    required this.order,
  });



  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'character': character,
      'profilePath': profilePath,
      'popularity': popularity,
      'order': order,
    };
  }

  factory Cast.fromMap(Map<String, dynamic> map) {
    return Cast(
      id: map['id'] as int,
      name: map['name'] as String,
      character: map['character'] as String,
      profilePath: map['profilePath'] != null ? map['profilePath'] as String : null,
      popularity: map['popularity'] as double,
      order: map['order'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Cast.fromJson(String source) => Cast.fromMap(json.decode(source) as Map<String, dynamic>);
}
