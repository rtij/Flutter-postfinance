import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter_application_1/shared/animatedBackground.dart';
import 'package:flutter_application_1/routes/routes.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      showThemeSwitcher: false,
      showPageIndicators: false,
      contentPadding: EdgeInsets.zero,
      content: Beamer(routerDelegate: homeRouterDelegate),
    );
  }
}
