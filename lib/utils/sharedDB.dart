import 'package:shared_preferences/shared_preferences.dart';

class SharedDB {
 static Future getGenre() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var genre = sp.getStringList('selectedGenre');
    return genre?.toSet() ?? {};
  }

 static Future<bool> skipONboard() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getBool('skipOnboard') ?? false;
  }
}
