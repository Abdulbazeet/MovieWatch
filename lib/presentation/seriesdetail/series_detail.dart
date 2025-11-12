import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_watch/models/movies.dart';

class SeriesDetails extends ConsumerStatefulWidget {
    final Movie? currentMovie;

  const SeriesDetails(this.currentMovie, {super.key});

  @override
  ConsumerState<SeriesDetails> createState() => _SeriesDetailsState();
}

class _SeriesDetailsState extends ConsumerState<SeriesDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
