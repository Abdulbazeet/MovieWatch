// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Videos {
  final int id;
  final List<Results> results;

  Videos({required this.id, required this.results});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'results': results.map((x) => x.toMap()).toList(),
    };
  }

  factory Videos.fromMap(Map<String, dynamic> map) {
    return Videos(
      id: map['id'] as int,
      results: List<Results>.from(
        (map['results'] as List<int>).map<Results>(
          (x) => Results.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Videos.fromJson(String source) =>
      Videos.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Results {
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
  Results({
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

  // Results({
  //   required this.id,
  //   required this.iso6391,
  //   required this.iso31661,
  //   required this.name,
  //   required this.key,
  //   required this.site,
  //   required this.size,
  //   required this.type,
  //   required this.official,
  //   required this.publishedAt,
  // });

  // factory Results.fromJson(Map<String, dynamic> json) {
  //   return Results(
  //     id: json['id'] ?? '',
  //     iso6391: json['iso_639_1'] ?? '',
  //     iso31661: json['iso_3166_1'] ?? '',
  //     name: json['name'] ?? '',
  //     key: json['key'] ?? '',
  //     site: json['site'] ?? '',
  //     size: json['size'] ?? 0,
  //     type: json['type'] ?? '',
  //     official: json['official'] ?? false,
  //     publishedAt:
  //         DateTime.tryParse(json['published_at'] ?? '') ?? DateTime.now(),
  //   );
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'iso_639_1': iso6391,
  //     'iso_3166_1': iso31661,
  //     'name': name,
  //     'key': key,
  //     'site': site,
  //     'size': size,
  //     'type': type,
  //     'official': official,
  //     'published_at': publishedAt.toIso8601String(),
  //   };
  // }

  // /// Returns the YouTube watch link (if site is YouTube)
  // String? get youtubeUrl {
  //   if (site.toLowerCase() == 'youtube' && key.isNotEmpty) {
  //     return 'https://www.youtube.com/watch?v=$key';
  //   }
  //   return null;
  // }

  // /// Returns the YouTube embed link (for WebViews or iframe players)
  // String? get youtubeEmbedUrl {
  //   if (site.toLowerCase() == 'youtube' && key.isNotEmpty) {
  //     return 'https://www.youtube.com/embed/$key';
  //   }
  //   return null;
  // }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'iso6391': iso6391,
      'iso31661': iso31661,
      'name': name,
      'key': key,
      'site': site,
      'size': size,
      'type': type,
      'official': official,
      'publishedAt': publishedAt.toIso8601String(),
    };
  }

  factory Results.fromMap(Map<String, dynamic> map) {
    return Results(
      id: map['id'] as String,
      iso6391: map['iso6391'] as String,
      iso31661: map['iso31661'] as String,
      name: map['name'] as String,
      key: map['key'] as String,
      site: map['site'] as String,
      size: map['size'] as int,
      type: map['type'] as String,
      official: map['official'] as bool,
      publishedAt: DateTime.fromMillisecondsSinceEpoch(
        map['publishedAt'] as int,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Results.fromJson(String source) =>
      Results.fromMap(json.decode(source) as Map<String, dynamic>);
}
