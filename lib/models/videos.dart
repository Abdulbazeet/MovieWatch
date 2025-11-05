class Video {
  final String id;
  final String iso6391;
  final String iso31661;
  final String name;
  final String key;
  final String site;
  final int size;
  final String type;
  final bool official;
  final DateTime publishedAt;

  Video({
    required this.id,
    required this.iso6391,
    required this.iso31661,
    required this.name,
    required this.key,
    required this.site,
    required this.size,
    required this.type,
    required this.official,
    required this.publishedAt,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'] ?? '',
      iso6391: json['iso_639_1'] ?? '',
      iso31661: json['iso_3166_1'] ?? '',
      name: json['name'] ?? '',
      key: json['key'] ?? '',
      site: json['site'] ?? '',
      size: json['size'] ?? 0,
      type: json['type'] ?? '',
      official: json['official'] ?? false,
      publishedAt:
          DateTime.tryParse(json['published_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'iso_639_1': iso6391,
      'iso_3166_1': iso31661,
      'name': name,
      'key': key,
      'site': site,
      'size': size,
      'type': type,
      'official': official,
      'published_at': publishedAt.toIso8601String(),
    };
  }

  /// Returns the YouTube watch link (if site is YouTube)
  String? get youtubeUrl {
    if (site.toLowerCase() == 'youtube' && key.isNotEmpty) {
      return 'https://www.youtube.com/watch?v=$key';
    }
    return null;
  }

  /// Returns the YouTube embed link (for WebViews or iframe players)
  String? get youtubeEmbedUrl {
    if (site.toLowerCase() == 'youtube' && key.isNotEmpty) {
      return 'https://www.youtube.com/embed/$key';
    }
    return null;
  }
}
