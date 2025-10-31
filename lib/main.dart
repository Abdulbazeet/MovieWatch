import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_watch/routes/routes.dart';
import 'package:movie_watch/theme/theme.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ProviderScope(
      child: DevicePreview(
        enabled: !kReleaseMode,
        defaultDevice: Devices.ios.iPhone16ProMax,
        builder: (context) => MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      footerTriggerDistance: 15,
      dragSpeedRatio: 0.91,
      headerBuilder: () => MaterialClassicHeader(),
      footerBuilder: () => ClassicFooter(),
      enableLoadingWhenNoData: false,
      enableRefreshVibrate: false,
      enableLoadMoreVibrate: false,
      shouldFooterFollowWhenNotFull: (state) {
        // If you want load more with noMoreData state ,may be you should return false
        return false;
      },
      child: 
      
      // ScreenUtilInit(
      //   designSize: const Size(430, 932),
      //   minTextAdapt: true,
      //   splitScreenMode: true,
      //   builder: (context, child) => child!,
      //   child: 
      // ),
      Sizer(builder: (context, orientation, screenType) => MaterialApp.router(
          debugShowCheckedModeBanner: false,
          locale: DevicePreview.locale(context),
          title: 'MoviewWatch',
          builder: DevicePreview.appBuilder,

          theme: AppTheme.lightmode,
          darkTheme: AppTheme.lightmode,
          routerConfig: AppRoutes.goRoute,
        ),)
    );
  }
}
