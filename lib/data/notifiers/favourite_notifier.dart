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
            ref.invalidate(isFavouriteProvider((id, mediaType)));

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
      ref.invalidate(isFavouriteProvider((id, mediaType)));
      state = const AsyncData('Removed from favourites');
    } catch (e, str) {
      state = AsyncError(e, str);
    }
  }

  // Future<bool> isFavourite(int id, MediaType mediaType) async {
  //   try {
  //     final operationsService = ref.read(operationsServicesProvider);
  //     final isFav = await operationsService.isFavourite(id, mediaType);
  //     // state = AsyncData(isFav);

  //     return isFav;
  //   } catch (e, str) {
  //     // state = AsyncError(e, str);
  //     return false;
  //   }
  // }
}

final favouriteNotifierProvider =
    AsyncNotifierProvider<FavouriteNotifier, dynamic>(
      () => FavouriteNotifier(),
    );
final isFavouriteProvider = FutureProvider.family<bool, (int, MediaType)>((
  ref,
  tuple,
) async {
  final (movieId, mediaType) = tuple;
  final service = ref.watch(operationsServicesProvider);
  return service.isFavourite(movieId, mediaType);
});
