import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:movie_watch/config/enums.dart';
import 'package:movie_watch/models/movie/movies.dart';
import 'package:movie_watch/models/user/userModel.dart';

class OperationsServices {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  //favourites operations;
  Future<void> addFavourite(int id, MediaType mediaType) async {
    final user = currentUser;
    if (user == null) {
      return;
    }
    MediaRef favWithUser = MediaRef(
      addedAt: DateTime.now(),
      id: id,
      mediaType: mediaType,
      user_id: user.uid,
    );
    await _firestore.collection('favourite').add(favWithUser.toMap());
  }

  Future<void> removeFavourite(int id, MediaType mediaType) async {
    final user = currentUser;
    if (user == null) {
      return;
    }
    final snapshot = await _firestore
        .collection('favourite')
        .where('user_id', isEqualTo: user.uid)
        .where('id', isEqualTo: id)
        .where('mediaType', isEqualTo: mediaType.value)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<bool> isFavourite(int id, MediaType mediaType) async {
    final user = currentUser;
    if (user == null) {
      return false;
    }
    final snapshot = await _firestore
        .collection('favourite')
        .where('user_id', isEqualTo: user.uid)
        .where('id', isEqualTo: id)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  /// seen list operations;

  Future<void> addSeenList(int id, MediaType mediaType) async {
    final user = currentUser;
    if (user == null) {
      return;
    }
    MediaRef seen = MediaRef(
      addedAt: DateTime.now(),
      id: id,
      mediaType: mediaType,
      user_id: user.uid,
    );
    await _firestore.collection('seenList').add(seen.toMap());
  }

  Future<void> removeSeenList(int id, MediaType mediaType) async {
    final user = currentUser;
    if (user == null) {
      return;
    }

    final snapshot = await _firestore
        .collection('seenList')
        .where('user_id', isEqualTo: user.uid)
        .where('id', isEqualTo: id)
        .where('mediaType', isEqualTo: mediaType.value)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<bool> isSeenYet(int id, MediaType mediaType) async {
    final user = currentUser;
    if (user == null) {
      return false;
    }
    final snapshot = await _firestore
        .collection('seenList')
        .where('user_id', isEqualTo: user.uid)
        .where('id', isEqualTo: id)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  Future<List<MediaRef>> getSeenList() async {
    final user = currentUser;
    if (user == null) {
      return [];
    }
    final snapshot = await _firestore
        .collection('seenList')
        .where('user_id', isEqualTo: user.uid)
        .orderBy('addedAt', descending: true)
        .get();

    return snapshot.docs.map((e) => MediaRef.fromMap(e.data())).toList();
  }

  /// watch list operations;
  Future<void> addWatchList(int id, MediaType mediaType) async {
    final user = currentUser;
    if (user == null) {
      return;
    }
    MediaRef watch = MediaRef(
      addedAt: DateTime.now(),
      id: id,
      mediaType: mediaType,
      user_id: user.uid,
    );
    await _firestore.collection('watchList').add(watch.toMap());
  }

  Future<void> removeWatchList(int id, MediaType mediaType) async {
    final user = currentUser;
    if (user == null) {
      return;
    }
    final snapshot = await _firestore
        .collection('watchList')
        .where('user_id', isEqualTo: user.uid)
        .where('id', isEqualTo: id)
        .where('mediaType', isEqualTo: mediaType.value)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<bool> isInWatchList(int id, MediaType mediaType) async {
    final user = currentUser;
    if (user == null) {
      return false;
    }
    final snapshot = await _firestore
        .collection('watchList')
        .where('user_id', isEqualTo: user.uid)
        .where('id', isEqualTo: id)
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  Future<List<Movie>> seenList(MediaType mediaType) async {
    final header = dotenv.env['HEADER'];
    if (header == null || header.isEmpty) {
      throw Exception('Missing TMDB auth header');
    }
    final user = currentUser;
    if (user == null) {
      return [];
    }
    final snapshot = await _firestore
        .collection('seenList')
        .where('user_id', isEqualTo: user.uid)
        .where('mediaType', isEqualTo: mediaType.value)
        .orderBy('addedAt', descending: true)
        .get();

    final refs = snapshot.docs.map((e) => MediaRef.fromMap(e.data())).toList();

    final futures = refs.map((ref) async {
      final typePath = ref.mediaType == MediaType.tv ? 'tv' : 'movie';
      final url =
          'https://api.themoviedb.org/3/$typePath/${ref.id}?language=en-US';
      final response = await get(
        Uri.parse(url),
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Bearer $header',
        },
      );
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to load details for ${ref.id} (${ref.mediaType.value})',
        );
      }
      final raw = jsonDecode(response.body) as Map<String, dynamic>;

      return Movie.fromJson(raw);
    }).toList();

    return Future.wait(futures);
  }

  Future<List<Movie>> favList(MediaType mediaType) async {
    final user = currentUser;
    if (user == null) {
      return [];
    }
    final header = dotenv.env['HEADER'];
    if (header == null || header.isEmpty) {
      throw Exception('Missing TMDB auth header');
    }
    final snapshot = await _firestore
        .collection('favourite')
        .where('user_id', isEqualTo: user.uid)
        .where('mediaType', isEqualTo: mediaType.value)
        .orderBy('addedAt', descending: true)
        .get();

    final parsedData = snapshot.docs
        .map((e) => MediaRef.fromMap(e.data()))
        .toList();

    final favDataList = parsedData.map((e) async {
      final typePath = e.mediaType == MediaType.tv ? 'tv' : 'movie';
      final url =
          'https://api.themoviedb.org/3/$typePath/${e.id}?language=en-US';
      final response = await get(
        Uri.parse(url),
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Bearer $header',
        },
      );
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to load details for ${e.id} (${e.mediaType.value})',
        );
      }
      final data = jsonDecode(response.body);
      return Movie.fromJson(data);
    }).toList();

    return Future.wait(favDataList);
  }
}

final operationsServicesProvider = Provider<OperationsServices>((ref) {
  return OperationsServices();
});
