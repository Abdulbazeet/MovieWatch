// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:movie_watch/config/enums.dart';
import 'package:movie_watch/models/movies.dart';

class Usermodel {
  String uid;
  // String? email;
  // String? password;
  final List<MediaRef>? favourite;
  final List<MediaRef>? seenList;
  final List<MediaRef>? watchList;
  Usermodel({
    required this.uid,
    // this.email,
    // this.password,
    required this.favourite,
    required this.seenList,
    required this.watchList,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      // 'email': email,
      // 'password': password,
      'favourite': favourite?.map((x) => x.toMap()).toList(),
      'seenList': seenList?.map((x) => x.toMap()).toList(),
      'watchList': watchList?.map((x) => x.toMap()).toList(),
    };
  }

  factory Usermodel.fromMap(Map<String, dynamic> map) {
    return Usermodel(
      uid: map['uid'] as String,
      // email: map['email'] != null ? map['email'] as String : null,
      // password: map['password'] != null ? map['password'] as String : null,
      favourite: map['favourite'] != null
          ? List<MediaRef>.from(
              (map['favourite']).map<MediaRef>((x) => MediaRef.fromMap(x)),
            )
          : null,
      seenList: map['seenList'] != null
          ? List<MediaRef>.from(
              (map['seenList']).map<MediaRef>((x) => MediaRef.fromMap(x)),
            )
          : null,
      watchList: map['watchList']
          ? List<MediaRef>.from(
              (map['watchList']).map<MediaRef>((x) => MediaRef.fromMap(x)),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Usermodel.fromJson(String source) =>
      Usermodel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class MediaRef {
  int id;
  final MediaType mediaType;
  final DateTime addedAt;
  MediaRef({required this.id, required this.mediaType, required this.addedAt});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'mediaType': mediaType.value,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory MediaRef.fromMap(Map<String, dynamic> map) {
    return MediaRef(
      id: map['id'] as int,
      mediaType: MediaType.fromString(map['mediaType']),
      addedAt: DateTime.parse(map['addedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MediaRef.fromJson(String source) =>
      MediaRef.fromMap(json.decode(source) as Map<String, dynamic>);
}
