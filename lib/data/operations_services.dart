import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_watch/config/enums.dart';
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
      addedAt: DateTime.now(),
      id: id,
      mediaType: mediaType,
      user_id: user.id,
    );
    await supabase
        .from('favourite')
        .delete()
        .eq('user_id', favourite.user_id)
        .eq('id', favourite.id)
        .eq('mediaType', favourite.mediaType.toString());
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
        .eq('user_id', favourite.user_id)
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
        .eq('mediaType', seen.mediaType.toString());
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
        .eq('mediaType', watch.mediaType.toString());
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
}

final operationsServicesProvider = Provider<OperationsServices>((ref) {
  return OperationsServices();
});
