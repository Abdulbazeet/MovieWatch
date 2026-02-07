import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_watch/firebase_options.dart';
import 'package:movie_watch/routes/routes.dart';
import 'package:movie_watch/theme/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  // await Supabase.initialize(
  //   anonKey: dotenv.env['SUPABASE_ANON']!,
  //   url: dotenv.env['SUPABASE_URL']!,
  // );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    // DevicePreview(
    //   enabled: !kReleaseMode,
    //   defaultDevice: Devices.ios.iPhone16ProMax,
    //   isToolbarVisible: true,
    //   builder: (context) => const ProviderScope(child: MyApp()),
    // ),
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      title: 'MoviewWatch',

      // These three lines are mandatory for DevicePreview
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,

      theme: AppTheme.lightmode,
      darkTheme: AppTheme.lightmode, // ← FIX THIS LINE

      routerConfig: AppRoutes.goRoute,
    );
  }
}
