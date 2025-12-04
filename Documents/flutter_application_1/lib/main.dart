import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/themeProvider.dart';
import 'package:localstorage/localstorage.dart';
import 'routes/routes.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          title: 'Neumorphic Login',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.isDarkMode ? _darkTheme : _lightTheme,

          // Beamer integration
          routerDelegate: routerDelegate,
          routeInformationParser: routeInformationParser,
        );
      },
    );
  }
}

// Thème clair (neumorphisme)
final ThemeData _lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFE0E5EC),
  colorScheme: const ColorScheme.light(
    primary: Colors.blueGrey,
    secondary: Colors.white,
  ),
);

// Thème sombre (neumorphisme)
final ThemeData _darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF232528),
  colorScheme: const ColorScheme.dark(
    primary: Colors.white,
    secondary: Color(0xFF3A3D40),
  ),
);