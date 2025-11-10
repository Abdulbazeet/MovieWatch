import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_watch/routes/routes.dart';
import 'package:movie_watch/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ProviderScope(
      child: 
      
      // DevicePreview(
      //   enabled: !kReleaseMode,
      //   defaultDevice: Devices.ios.iPhone16ProMax,
      //   builder: (context) => MyApp(),
      // ),
       MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 851),

      // const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'MoviewWatch',

        // locale: DevicePreview.locale(context),
        // builder: DevicePreview.appBuilder,

        theme: AppTheme.lightmode,
        darkTheme: AppTheme.lightmode,
        routerConfig: AppRoutes.goRoute,
      ),
    );
  }
}
