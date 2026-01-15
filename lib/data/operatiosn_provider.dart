import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_watch/data/operations_services.dart';
import 'package:movie_watch/models/user/userModel.dart';

final operationsServicesProvider = Provider<OperationsServices>(
  (ref) => OperationsServices(),
);

final addFavouriteProvider = Provider.family<Future<void>, MediaRef>((
  ref,
  param,
) {
  final operationsService = ref.watch(operationsServicesProvider);
  return operationsService.addFavourite(param);
});
final removeFavouriteProvider = Provider.family<Future<void>, MediaRef>((
  ref,
  param,
) {
  final operationsService = ref.watch(operationsServicesProvider);
  return operationsService.removeFavourite(param);
});
final isFavouriteProvider = Provider.family<Future<bool>, MediaRef>((
  ref,
  param,
) {
  final operationsService = ref.watch(operationsServicesProvider);
  return operationsService.isFavourite(param);
});

final addSeenListProvider = Provider.family<Future<void>, MediaRef>((
  ref,
  param,
) {
  final operationsService = ref.watch(operationsServicesProvider);
  return operationsService.addSeenList(param);
});
final removeSeenListProvider = Provider.family<Future<void>, MediaRef>((
  ref,
  param,
) {
  final operationsService = ref.watch(operationsServicesProvider);
  return operationsService.removeSeenList(param);
});
final isSeenListProvider = Provider.family<Future<bool>, MediaRef>((
  ref,
  param,
) {
  final operationsService = ref.watch(operationsServicesProvider);
  return operationsService.isSeenYet(param);
});
final addWatchListProvider = Provider.family<Future<void>, MediaRef>((
  ref,
  param,
) {
  final operationsService = ref.watch(operationsServicesProvider);
  return operationsService.addWatchList(param);
});
final removeWatchListProvider = Provider.family<Future<void>, MediaRef>((
  ref,
  param,
) {
  final operationsService = ref.watch(operationsServicesProvider);
  return operationsService.removeWatchList(param);
});
final isWatchListProvider = Provider.family<Future<bool>, MediaRef>((
  ref,
  param,
) {
  final operationsService = ref.watch(operationsServicesProvider);
  return operationsService.isInWatchList(param);
});
