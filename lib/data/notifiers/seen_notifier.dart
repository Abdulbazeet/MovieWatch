import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_watch/config/enums.dart';
import 'package:movie_watch/data/operations_services.dart';
import 'package:movie_watch/models/user/userModel.dart';

class SeenNotifier extends AsyncNotifier {
  @override
  FutureOr<dynamic> build() {
    return null;
  }

  Future<void> addSeen(int id, MediaType medaiType) async {
    state = const AsyncLoading();
    try {
      final operationService = ref.read(operationsServicesProvider);
      await operationService.addSeenList(id, medaiType);
      ref.invalidate(isSeenProvider((id, medaiType)));
      state = const AsyncData('Added to seen list');
    } catch (e, str) {
      print(e);
      state = AsyncError(e, str);
    }
  }

  Future<void> removeSeen(int id, MediaType mediaType) async {
    state = const AsyncLoading();
    try {
      final operationService = ref.read(operationsServicesProvider);
      await operationService.removeSeenList(id, mediaType);
      ref.invalidate(isSeenProvider((id, mediaType)));
      state = const AsyncData('Removed from seen list');
    } catch (e, str) {
      print(e);
      state = AsyncError(e, str);
    }
  }
}

final seenNotifierProvider = AsyncNotifierProvider<SeenNotifier, dynamic>(() {
  return SeenNotifier();
});

final isSeenProvider = FutureProvider.family<bool, (int, MediaType)>((
  ref,
  param,
) async {
  final (id, mediaType) = param;
  final service = ref.watch(operationsServicesProvider);

  return service.isSeenYet(id, mediaType);
});

// final seenListProvider = FutureProvider<List<MediaRef>>((ref) async {
//   final service = ref.watch(operationsServicesProvider);
//   return service.getSeenList();
// });
