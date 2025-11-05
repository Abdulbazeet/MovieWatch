import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class Credits {
  final int id;
  final List<Cast> cast;

  Credits({required this.id, required this.cast});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'cast': cast.map((x) => x.toMap()).toList(),
    };
  }

  factory Credits.fromMap(Map<String, dynamic> map) {
    return Credits(
      id: map['id'] as int,
      cast: List<Cast>.from(
        (map['cast'] as List).map(
          (x) => Cast.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Credits.fromJson(String source) =>
      Credits.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Cast {
  final bool adult;

  final int gender;
  final int id;
  final String known_for_department;
  final String name;
  final String original_name;
  final double popularity;
  final String profile_path;
  final int cast_id;
  final String character;
  final double credit_id;
  final int order;
  Cast({
    required this.adult,
    required this.gender,
    required this.id,
    required this.known_for_department,
    required this.name,
    required this.original_name,
    required this.popularity,
    required this.profile_path,
    required this.cast_id,
    required this.character,
    required this.credit_id,
    required this.order,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'adult': adult,
      'gender': gender,
      'id': id,
      'known_for_department': known_for_department,
      'name': name,
      'original_name': original_name,
      'popularity': popularity,
      'profile_path': profile_path,
      'cast_id': cast_id,
      'character': character,
      'credit_id': credit_id,
      'order': order,
    };
  }

  factory Cast.fromMap(Map<String, dynamic> map) {
    return Cast(
      adult: map['adult'] as bool,
      gender: map['gender'] as int,
      id: map['id'] as int,
      known_for_department: map['known_for_department'] as String,
      name: map['name'] as String,
      original_name: map['original_name'] as String,
      popularity: map['popularity'] as double,
      profile_path: map['profile_path'] as String,
      cast_id: map['cast_id'] as int,
      character: map['character'] as String,
      credit_id: map['credit_id'] as double,
      order: map['order'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Cast.fromJson(String source) =>
      Cast.fromMap(json.decode(source) as Map<String, dynamic>);
}
