import 'package:beamer/beamer.dart';
import 'package:flutter_application_1/screens/Home/home.dart';
import 'package:localstorage/localstorage.dart';
import '../screens/Login/login.dart';

bool isLoggedIn() {
  final token = localStorage.getItem('token');
  return token != null && token.toString().isNotEmpty;
}

class AuthGuard extends BeamGuard {
  AuthGuard()
    : super(
        pathPatterns: ['/login'],
        // perform the check on all patterns that **don't** have a match in pathPatterns
        guardNonMatching: true,
        // return false to redirect
        check: (context, location) => isLoggedIn(),
        // where to redirect on a false check
        beamToNamed: (origin, target) => '/login',
      );
}

final routerDelegate = BeamerDelegate(
  initialPath: '/login',
  guards: [AuthGuard()],
  locationBuilder: RoutesLocationBuilder(
    routes: {
      '/login': (context,data, state) => const LoginPage(),
      '/home': (context,data, state) => const Home(),
    },
  ).call,
);

final routeInformationParser = BeamerParser();
