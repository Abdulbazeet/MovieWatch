import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_watch/config/movie_type.dart';
import 'package:movie_watch/data/notifiers/movie-details_notifiers.dart';
import 'package:movie_watch/data/tmdb_providers.dart';
import 'package:movie_watch/models/movies.dart';

class Details extends ConsumerStatefulWidget {
  final Movie? currentMovie;
  final TableType tableTYpe;
  const Details({
    super.key,
    required this.currentMovie,
    required this.tableTYpe,
  });

  @override
  ConsumerState<Details> createState() => _DetailsState();
}

class _DetailsState extends ConsumerState<Details> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // final movieDetaiil = ref.watch(
    //   movieDetailsNotifierProvider(widget.currentMovie!.id),
    // );
    final m = ref.watch(test(widget.currentMovie!.id));
    return Scaffold(
      body: Center(
        child: m.when(
          data: (data) => Text(data.original_title),
          error: (error, stackTrace) {
            return Text(error.toString());
          },
          loading: () {
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
