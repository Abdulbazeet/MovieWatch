import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class Utils{
static void checkConection(bool isOnline)async{
   Connectivity().onConnectivityChanged.listen((event) {
      final hasInternet =  InternetConnectionChecker().hasConnection;
      
    });
}
}