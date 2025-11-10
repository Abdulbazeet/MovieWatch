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
      id: map['id'] ?? 0,
      results: List<Results>.from(
        (map['results'] as List).map((x) => Results.fromMap(x)),
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
      id: map['id'] ?? '',
      iso6391: map['iso_639_1'] ?? '',
      iso31661: map['iso_3166_1'] ?? '',
      name: map['name'] ?? '',
      key: map['key'] ?? '',
      site: map['site'] ?? '',
      size: map['size'] ?? 0,
      type: map['type'] ?? '',
      official: map['official'] as bool,
      publishedAt: DateTime.parse(map['published_at']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Results.fromJson(String source) =>
      Results.fromMap(json.decode(source) as Map<String, dynamic>);
}
