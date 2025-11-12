import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_watch/config/enums.dart';
import 'package:movie_watch/models/movies.dart';

class TvshowScreen extends ConsumerStatefulWidget {
  final Movie? currentMovie;
  final TableType tableType;
  const TvshowScreen({
    super.key,
    required this.currentMovie,
    required this.tableType,
  });

  @override
  ConsumerState<TvshowScreen> createState() => _TvshowScreenState();
}

class _TvshowScreenState extends ConsumerState<TvshowScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
