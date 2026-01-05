import 'package:flutter_dotenv/flutter_dotenv.dart';

class TmdbConfig {
  static final String apiKey = dotenv.env['TMDB_API']!;
  static final String img_url = "https://image.tmdb.org/t/p/";
}
