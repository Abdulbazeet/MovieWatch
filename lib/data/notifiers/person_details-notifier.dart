import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_watch/data/tmdb_providers.dart';
import 'package:movie_watch/models/person/person-credits.dart';
import 'package:movie_watch/models/person/person_bundle.dart';
import 'package:movie_watch/models/person/person_details.dart';

class PersonDetailsNotifier extends AsyncNotifier<PersonBundle> {
  late int personId;

  @override
  FutureOr<PersonBundle> build() {
    return fetchPersonDetals(personId);
  }

  Future<PersonBundle> fetchPersonDetals(int personId) async {
    var api = ref.read(tmdbserviceProvider);
    final data = await Future.wait([
      api.fetchPersonCredits(personId),
      api.fetchPersonDetails(personId),
    ]);
    final personDetails = PersonBundle(
      personCredits: data[0] as List<PersonCredits>,
      personDetails: data[1] as PersonDetails,
    );
    return personDetails;
  }
}

final personDetailsNotifierProvider =
    AsyncNotifierProvider.family<PersonDetailsNotifier, PersonBundle, int>(
      (arg) => PersonDetailsNotifier()..personId = arg,
    );
