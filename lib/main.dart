import 'package:flutter/material.dart';
import 'package:movie_watch/routes/routes.dart';
import 'package:movie_watch/theme/theme.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightmode,
          darkTheme: AppTheme.darkMode,
          routerConfig: AppRoutes.goRoute,
        );
      },
    );
  }
}
