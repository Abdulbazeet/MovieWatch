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

  Future<bool> isFavourite(MediaRef favourite) async {
    final user = currentUser;
    if (user == null) {
      return false;
    }
    final check = await supabase
        .from('favourite')
        .select()
        .eq('user_id', favourite.user_id)
        .eq('id', favourite.id)
        .maybeSingle();
    return check != null;
  }

  /// seen list operations;

  Future<void> addSeenList(MediaRef seen) async {
    final user = currentUser;
    if (user == null) {
      return;
    }
    await supabase.from('seen_list').insert(seen.toMap());
  }

  Future<void> removeSeenList(MediaRef seen) async {
    final user = currentUser;
    if (user == null) {
      return;
    }
    await supabase
        .from('seenList')
        .delete()
        .eq('user_id', seen.user_id)
        .eq('id', seen.id)
        .eq('mediaType', seen.mediaType.toString());
  }

  Future<bool> isSeenYet(MediaRef seen) async {
    final user = currentUser;
    if (user == null) {
      return false;
    }
    final check = await supabase
        .from('seenList')
        .select()
        .eq('user_id', seen.user_id)
        .eq('id', seen.id)
        .maybeSingle();
    return check != null;
  }

  /// watch list operations;
  Future<void> addWatchList(MediaRef watch) async {
    final user = currentUser;
    if (user == null) {
      return;
    }
    await supabase.from('watchList').insert(watch.toMap());
  }

  Future<void> removeWatchList(MediaRef watch) async {
    final user = currentUser;
    if (user == null) {
      return;
    }
    await supabase
        .from('watchList')
        .delete()
        .eq('user_id', watch.user_id)
        .eq('id', watch.id)
        .eq('mediaType', watch.mediaType.toString());
  }

  Future<bool> isInWatchList(MediaRef watch) async {
    final user = currentUser;
    if (user == null) {
      return false;
    }
    final check = await supabase
        .from('watchList')
        .select()
        .eq('user_id', watch.user_id)
        .eq('id', watch.id)
        .maybeSingle();
    return check != null;
  }
}
