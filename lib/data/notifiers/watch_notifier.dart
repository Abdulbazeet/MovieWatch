import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_watch/config/enums.dart';
import 'package:movie_watch/data/operations_services.dart';

class WatchNotifier extends AsyncNotifier {
  @override
  FutureOr<dynamic> build() {
    return null;
  }

  Future<void> addWatch(int id, MediaType mediaType) async {
    state = const AsyncLoading();
    try {
      final operationService = ref.read(operationsServicesProvider);
      await operationService.addWatchList(id, mediaType);
      ref.invalidate(isInWatchListProvider((id, mediaType)));
      state = const AsyncData('Added to watch list');
    } catch (e, str) {
      print(e);
      state = AsyncError(e, str);
    }
  }

  Future<void> removeWatch(int id, MediaType mediaType) async {
    state = const AsyncLoading();
    try {
      final operationService = ref.read(operationsServicesProvider);
      await operationService.removeWatchList(id, mediaType);
      ref.invalidate(isInWatchListProvider((id, mediaType)));
      state = const AsyncData('Removed from watch list');
    } catch (e, str) {
      print(e);
      state = AsyncError(e, str);
    }
  }
}

final watchNotifierProvider = AsyncNotifierProvider<WatchNotifier, dynamic>(
  () => WatchNotifier(),
);
final isInWatchListProvider = FutureProvider.family<bool, (int, MediaType)>((
  ref,
  param,
) async {
  final (id, mediaType) = param;
  final service = ref.watch(operationsServicesProvider);

  return service.isInWatchList(id, mediaType);
});
