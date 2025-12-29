// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

class SeriesTrailers {
  final int id;
  final List<Trailer> results;

  SeriesTrailers({required this.id, required this.results});

  factory SeriesTrailers.fromMap(Map<String, dynamic> map) => SeriesTrailers(
    id: map['id'],
    results: (map['results'] as List<dynamic>)
        .map((e) => Trailer.fromMap(e))
        .toList(),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'results': results.map((e) => e.toMap()).toList(),
  };

  static List<SeriesTrailers> listFromMap(List<dynamic> list) =>
      list.map((e) => SeriesTrailers.fromMap(e)).toList();
}

class Trailer {
  final String iso6391;
  final String iso31661;
  final String name;
  final String key;
  final String site;
  final int size;
  final String type;
  final bool official;
  final String publishedAt;
  final String id;

  Trailer({
    required this.iso6391,
    required this.iso31661,
    required this.name,
    required this.key,
    required this.site,
    required this.size,
    required this.type,
    required this.official,
    required this.publishedAt,
    required this.id,
  });

  factory Trailer.fromMap(Map<String, dynamic> map) => Trailer(
    iso6391: map['iso_639_1'] ?? '',
    iso31661: map['iso_3166_1'] ?? '',
    name: map['name'] ?? '',
    key: map['key'] ?? '',
    site: map['site'] ?? '',
    size: map['size'] ?? 0,
    type: map['type'] ?? '',
    official: map['official'] ?? false,
    publishedAt: map['published_at'] ?? '',
    id: map['id'] ?? '',
  );

  Map<String, dynamic> toMap() => {
    'iso_639_1': iso6391,
    'iso_3166_1': iso31661,
    'name': name,
    'key': key,
    'site': site,
    'size': size,
    'type': type,
    'official': official,
    'published_at': publishedAt,
    'id': id,
  };

  static List<Trailer> listFromMap(List<dynamic> list) =>
      list.map((e) => Trailer.fromMap(e)).toList();
}
