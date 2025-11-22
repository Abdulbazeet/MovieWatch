import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class Utils {
  static void checkConection(bool isOnline) async {
    Connectivity().onConnectivityChanged.listen((event) {
      final hasInternet = InternetConnectionChecker().hasConnection;
    });
  }

  static String timeDuration(int minutes) {
    final duration = Duration(minutes: minutes);
    final hour = duration.inHours;
    final minute = duration.inMinutes.remainder(60);
    if (minute == 0) {
      return '${hour}h';
    } else if (hour == 0) {
      return '${minute}m';
    } else {
      return '${hour}h ${minute}m';
    }
  }
}
