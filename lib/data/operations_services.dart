import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:movie_watch/config/enums.dart';
import 'package:movie_watch/models/movie/movies.dart';
import 'package:movie_watch/models/user/userModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OperationsServices {
  final supabase = Supabase.instance.client;
  User? get currentUser => supabase.auth.currentUser;

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
      user_id: user.id,
    );
    await supabase.from('favourite').insert(favWithUser.toMap());
  }

  Future<void> removeFavourite(int id, MediaType mediaType) async {
    final user = currentUser;
    if (user == null) {
      return;
    }
    MediaRef favourite = MediaRef(
      id: id,
      mediaType: mediaType,
      user_id: user.id,
    );
    await supabase
        .from('favourite')
        .delete()
        .eq('user_id', favourite.user_id)
        .eq('id', favourite.id)
        .eq('mediaType', favourite.mediaType.value)
        .select();
    // .maybeSingle();
  }

  Future<bool> isFavourite(int id, MediaType mediaType) async {
    final user = currentUser;
    if (user == null) {
      return false;
    }
    MediaRef favourite = MediaRef(
      addedAt: DateTime.now(),
      id: id,
      mediaType: mediaType,
      user_id: user.id,
    );
    final check = await supabase
        .from('favourite')
        .select()
        .eq('user_id', user.id)
        .eq('id', favourite.id)
        .maybeSingle();
    return check != null;
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
      user_id: user.id,
    );
    await supabase.from('seenList').insert(seen.toMap());
  }

  Future<void> removeSeenList(int id, MediaType mediaType) async {
    final user = currentUser;
    if (user == null) {
      return;
    }

    MediaRef seen = MediaRef(
      addedAt: DateTime.now(),
      id: id,
      mediaType: mediaType,
      user_id: user.id,
    );
    await supabase
        .from('seenList')
        .delete()
        .eq('user_id', seen.user_id)
        .eq('id', seen.id)
        .eq('mediaType', seen.mediaType.value);
  }

  Future<bool> isSeenYet(int id, MediaType mediaType) async {
    final user = currentUser;
    if (user == null) {
      return false;
    }
    MediaRef seen = MediaRef(
      addedAt: DateTime.now(),
      id: id,
      mediaType: mediaType,
      user_id: user.id,
    );
    final check = await supabase
        .from('seenList')
        .select()
        .eq('user_id', seen.user_id)
        .eq('id', seen.id)
        .maybeSingle();
    return check != null;
  }

  Future<List<MediaRef>> getSeenList() async {
    final user = currentUser;
    if (user == null) {
      return [];
    }
    final data = await supabase
        .from('seenList')
        .select()
        .eq('user_id', user.id)
        .order('addedAt', ascending: false);
    return data.map<MediaRef>((e) => MediaRef.fromMap(e)).toList();
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
      user_id: user.id,
    );
    await supabase.from('watchList').insert(watch.toMap());
  }

  Future<void> removeWatchList(int id, MediaType mediaType) async {
    final user = currentUser;
    if (user == null) {
      return;
    }
    MediaRef watch = MediaRef(
      addedAt: DateTime.now(),
      id: id,
      mediaType: mediaType,
      user_id: user.id,
    );
    await supabase
        .from('watchList')
        .delete()
        .eq('user_id', watch.user_id)
        .eq('id', watch.id)
        .eq('mediaType', watch.mediaType.value);
  }

  Future<bool> isInWatchList(int id, MediaType mediaType) async {
    final user = currentUser;
    if (user == null) {
      return false;
    }
    MediaRef watch = MediaRef(
      addedAt: DateTime.now(),
      id: id,
      mediaType: mediaType,
      user_id: user.id,
    );
    final check = await supabase
        .from('watchList')
        .select()
        .eq('user_id', watch.user_id)
        .eq('id', watch.id)
        .maybeSingle();
    return check != null;
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
    final data = await supabase
        .from('seenList')
        .select()
        .eq('user_id', user.id)
        .eq('mediaType', mediaType.value)
        .order('addedAt', ascending: false);
    final refs = data.map<MediaRef>((e) => MediaRef.fromMap(e)).toList();
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
    final data = await supabase
        .from('favourite')
        .select()
        .eq('user_id', user.id)
        .eq('mediaType', mediaType.value)
        .order('addedAt', ascending: false);
    final parsedData = data.map((e) => MediaRef.fromMap(e)).toList();
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
  // Future<List>
}

final operationsServicesProvider = Provider<OperationsServices>((ref) {
  return OperationsServices();
});
