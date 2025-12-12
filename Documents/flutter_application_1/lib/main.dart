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
          theme: themeProvider.isDarkMode ? darkTheme : lightTheme,

          // Beamer integration
          routerDelegate: routerDelegate,
          routeInformationParser: routeInformationParser,
        );
      },
    );
  }
}
