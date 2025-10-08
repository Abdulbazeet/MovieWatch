import 'package:go_router/go_router.dart';
import 'package:movie_watch/presentation/onboard/onboard.dart';

class AppRoutes {
  static final  GoRouter goRoute = GoRouter(
    routes: [GoRoute(path: '/', builder: (context, state) => const OnBoard())],
  );
}
