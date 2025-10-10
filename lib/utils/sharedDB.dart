import 'package:shared_preferences/shared_preferences.dart';

class SharedDB {
  Future getGenre() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var genre = sp.getStringList('selectedGenre');
    return genre?.toSet() ?? {};
  }
}
