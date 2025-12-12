import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool? _isDarkMode;
  SharedPreferences? _prefs;
  bool _isInitialized = false;

  ThemeProvider() {
    _loadThemePreference();
  }

  bool get isInitialized => _isInitialized;

  bool get isDarkMode {
    if (_isDarkMode == null) {
      // Si pas de préférence définie, utiliser le thème du système
      final brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    }
    return _isDarkMode!;
  }

  // Getter pour savoir si on suit le thème système
  bool get isFollowingSystem => _isDarkMode == null;

  ThemeData get currentTheme => isDarkMode ? _darkTheme : _lightTheme;

  // Charger la préférence sauvegardée
  Future<void> _loadThemePreference() async {
    _prefs = await SharedPreferences.getInstance();
    
    final followSystem = _prefs?.getBool('followSystem') ?? true;
    if (followSystem) {
      _isDarkMode = null; // Suivre le système
    } else {
      _isDarkMode = _prefs?.getBool('isDarkMode') ?? false;
    }
    
    _isInitialized = true;
    notifyListeners();
  }

  // Sauvegarder la préférence
  Future<void> _saveThemePreference() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    
    if (_isDarkMode == null) {
      await _prefs?.setBool('followSystem', true);
    } else {
      await _prefs?.setBool('followSystem', false);
      await _prefs?.setBool('isDarkMode', _isDarkMode!);
    }
  }

  // Basculer entre light/dark
  Future<void> toggleTheme() async {
    if (_isDarkMode == null) {
      // Si on suit le système, basculer vers le mode opposé
      final brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
      _isDarkMode = brightness == Brightness.light; // Inverse du système
    } else {
      _isDarkMode = !_isDarkMode!;
    }
    await _saveThemePreference();
    notifyListeners();
  }

  // Définir manuellement le mode sombre
  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    await _saveThemePreference();
    notifyListeners();
  }

  // Réinitialiser pour suivre le thème système
  Future<void> followSystemTheme() async {
    _isDarkMode = null;
    await _saveThemePreference();
    notifyListeners();
  }
}

// Thème clair avec gradient moderne
final ThemeData _lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFf3e7e9), // Base gradient color
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF6366f1), // Indigo
    secondary: Color(0xFF8b5cf6), // Purple
    tertiary: Color(0xFFec4899), // Pink
    error: Color(0xFFfbbf24), // Yellow
    surface: Colors.white,
    background: Color(0xFFf3e7e9),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Color(0xFF1f2937),
    onBackground: Color(0xFF1f2937),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      color: Color(0xFF1f2937),
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(color: Color(0xFF6b7280)),
    bodyMedium: TextStyle(color: Color(0xFF6b7280)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF6366f1),
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white.withOpacity(0.5),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: Colors.white.withOpacity(0.3),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: Colors.white.withOpacity(0.3),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: Color(0xFF6366f1),
        width: 2,
      ),
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return const Color(0xFF6366f1);
      }
      return Colors.transparent;
    }),
    checkColor: MaterialStateProperty.all(Colors.white),
  ),
);

// Thème sombre avec gradient moderne
final ThemeData _darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF16213e), // Base gradient color
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF818cf8), // Light Indigo
    secondary: Color(0xFFa78bfa), // Light Purple
    tertiary: Color(0xFFf472b6), // Light Pink
    surface: Color(0xFF1a1a2e),
    background: Color(0xFF16213e),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    onBackground: Colors.white,
  ),
  textTheme: TextTheme(
    displayLarge: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(color: Colors.white.withOpacity(0.7)),
    bodyMedium: TextStyle(color: Colors.white.withOpacity(0.7)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF6366f1),
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white.withOpacity(0.05),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: Colors.white.withOpacity(0.1),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: Colors.white.withOpacity(0.1),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: Color(0xFF818cf8),
        width: 2,
      ),
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.selected)) {
        return const Color(0xFF6366f1);
      }
      return Colors.transparent;
    }),
    checkColor: MaterialStateProperty.all(Colors.white),
  ),
);
ThemeData get darkTheme => _darkTheme;
ThemeData get lightTheme => _lightTheme;