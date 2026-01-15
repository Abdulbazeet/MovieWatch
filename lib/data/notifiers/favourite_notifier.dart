import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_watch/config/enums.dart';
import 'package:movie_watch/data/operations_services.dart';

class FavouriteNotifier extends AsyncNotifier {
  @override
  FutureOr<dynamic> build() {
    return null;
  }

  Future<void> addFavourite(int id, MediaType mediaType) async {
    state = const AsyncLoading();
    try {
      final operationsService = ref.read(operationsServicesProvider);
      await operationsService.addFavourite(id, mediaType);
      state = const AsyncData('Added to favourites');
    } catch (e, str) {
      state = AsyncError(e, str);
    }
  }

  Future<void> removeFavourite(int id, MediaType mediaType) async {
    state = const AsyncLoading();
    try {
      final operationsService = ref.read(operationsServicesProvider);
      await operationsService.removeFavourite(id, mediaType);
      state = const AsyncData('Removed from favourites');
    } catch (e, str) {
      state = AsyncError(e, str);
    }
  }

  Future<bool> isFavourite(int id, MediaType mediaType) async {
    final operationsService = ref.read(operationsServicesProvider);
    return operationsService.isFavourite(id, mediaType);
  }
}

final favouriteNotifierProvider =
    AsyncNotifierProvider<FavouriteNotifier, dynamic>(
      () => FavouriteNotifier(),
    );
