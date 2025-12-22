import 'package:beamer/beamer.dart';
import 'package:flutter_application_1/screens/Client-space/Dashboard/dashboard.dart';
import 'package:flutter_application_1/screens/Client-space/Home/home.dart';
import 'package:flutter_application_1/screens/Test/parent.dart';
import 'package:localstorage/localstorage.dart';
import '../screens/Login/login.dart';
import '../screens/forgot-password/forgot-password.dart';
import '../screens/Client-space/profile/profile.dart';
import '../screens/notFound.dart';

bool isLoggedIn() {
  final token = localStorage.getItem('token');
  print('Token found: $token');
  return token != null && token.toString().isNotEmpty;
}

class AuthGuard extends BeamGuard {
  AuthGuard()
    : super(
        pathPatterns: ['/login', '/forgotten-password'],
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
      '/parent': (context,data, state) => const ParentWidget(),
      '/forgotten-password': (context,data, state) => const ForgottenPassword(),
    },
  ).call,
  notFoundPage: const BeamPage(
    title: 'Page introuvable',
    child: NotFoundPage(),
  ),
);



// Client space routes
final homeRouterDelegate = BeamerDelegate(
  initialPath: '/home/profile',
  locationBuilder: RoutesLocationBuilder(
    routes: {
      '/home/dashboard': (context,data, state) => const Dashboard(),
      '/home/profile': (context,data, state) => const ProfileScreen(),
    },
  ).call,
);

final routeInformationParser = BeamerParser();
