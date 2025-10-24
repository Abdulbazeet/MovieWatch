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

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      character: json['character'] ?? '',
      profilePath: json['profile_path'],
      popularity: (json['popularity'] != null)
          ? json['popularity'].toDouble()
          : 0.0,
      order: json['order'] ?? 0,
    );
  }

  static List<Cast> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Cast.fromJson(json)).toList();
  }
}
