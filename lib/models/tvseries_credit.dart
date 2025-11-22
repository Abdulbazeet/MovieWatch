// ignore_for_file: public_member_api_docs, sort_constructors_first

class TvSeriesCredits {
  final bool adult;
  final int gender;
  final int id;
  final String knownForDepartment;
  final String name;
  final String originalName;
  final double popularity;
  final String? profilePath;
  final List<Role> roles;
  final int totalEpisodeCount;
  final int order;

  TvSeriesCredits({
    required this.adult,
    required this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    this.profilePath,
    required this.roles,
    required this.totalEpisodeCount,
    required this.order,
  });

  factory TvSeriesCredits.fromMap(Map<String, dynamic> map) => TvSeriesCredits(
    adult: map['adult'] ?? false,
    gender: map['gender'] ?? 0,
    id: map['id'],
    knownForDepartment: map['known_for_department'] ?? '',
    name: map['name'] ?? '',
    originalName: map['original_name'] ?? '',
    popularity: (map['popularit`y'] ?? 0).toDouble(),
    profilePath: map['profile_path'],
    roles: map['roles'] == null
        ? []
        : List<Role>.from((map['roles'] as List).map((e) => Role.fromMap(e))),
    totalEpisodeCount: map['total_episode_count'] ?? 0,
    order: map['order'] ?? 0,
  );

  Map<String, dynamic> toMap() => {
    'adult': adult,
    'gender': gender,
    'id': id,
    'known_for_department': knownForDepartment,
    'name': name,
    'original_name': originalName,
    'popularity': popularity,
    'profile_path': profilePath,
    'roles': roles.map((e) => e.toMap()).toList(),
    'total_episode_count': totalEpisodeCount,
    'order': order,
  };

  static List<TvSeriesCredits> listFromMap(List<dynamic> list) =>
      list.map((e) => TvSeriesCredits.fromMap(e)).toList();
}

class Role {
  final String creditId;
  final String character;
  final int episodeCount;

  Role({
    required this.creditId,
    required this.character,
    required this.episodeCount,
  });

  factory Role.fromMap(Map<String, dynamic> map) => Role(
    creditId: map['credit_id'] ?? '',
    character: map['character'] ?? '',
    episodeCount: map['episode_count'] ?? 0,
  );

  Map<String, dynamic> toMap() => {
    'credit_id': creditId,
    'character': character,
    'episode_count': episodeCount,
  };
}
