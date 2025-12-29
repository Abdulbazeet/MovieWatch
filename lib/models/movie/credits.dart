import 'dart:convert';

class Credits {
  final int id;
  final List<Cast> cast;

  Credits({required this.id, required this.cast});

  factory Credits.fromMap(Map<String, dynamic> map) {
    return Credits(
      id: map['id'] ?? 0,
      cast: map['cast'] == null
          ? []
          : List<Cast>.from((map['cast'] as List).map((x) => Cast.fromMap(x))),
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'cast': cast.map((x) => x.toMap()).toList()};
  }

  factory Credits.fromJson(String source) =>
      Credits.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}

class Cast {
  final bool adult;
  final int gender;
  final int id;
  final String known_for_department;
  final String name;
  final String originalName;
  final double popularity;
  final String? profilePath;
  final int castId;
  final String character;
  final String creditId;
  final int order;

  Cast({
    required this.adult,
    required this.gender,
    required this.id,
    required this.known_for_department,
    required this.name,
    required this.originalName,
    required this.popularity,
    required this.profilePath,
    required this.castId,
    required this.character,
    required this.creditId,
    required this.order,
  });

  factory Cast.fromMap(Map<String, dynamic> map) {
    return Cast(
      adult: map['adult'] ?? false,
      gender: map['gender'] ?? 0,
      id: map['id'] ?? 0,
      known_for_department: map['known_for_department'] ?? '',
      name: map['name'] ?? '',
      originalName: map['original_name'] ?? '',
      popularity: (map['popularity'] ?? 0).toDouble(),
      profilePath: map['profile_path'] ?? '',
      castId: map['cast_id'] ?? 0,
      character: map['character'] ?? '',
      creditId: map['credit_id'] ?? '',
      order: map['order'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'adult': adult,
      'gender': gender,
      'id': id,
      'known_for_department': known_for_department,
      'name': name,
      'original_name': originalName,
      'popularity': popularity,
      'profile_path': profilePath,
      'cast_id': castId,
      'character': character,
      'credit_id': creditId,
      'order': order,
    };
  }

  factory Cast.fromJson(String source) => Cast.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}
