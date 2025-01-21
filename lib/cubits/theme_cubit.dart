import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(_buildThemeData(Brightness.light),);

  void updateTheme(Brightness brightness) {
    emit(_buildThemeData(brightness));
  }

  void toggleTheme() {
    final isDark = state.brightness == Brightness.dark;
    emit(_buildThemeData(isDark ? Brightness.light : Brightness.dark));
  }

  static ThemeData _buildThemeData(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    return !isDark ? ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: Colors.lightGreen,
        onPrimary: Colors.lightGreen[700]!,
        inversePrimary: Colors.lightGreen[900],
        secondary: Colors.black87,
        error: Colors.white70,
        surface: Colors.white,
        tertiary: Colors.lightGreen[50],
        outline: Colors.black54,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w900, fontFamily: 'Inter'),
        titleSmall: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w300, fontFamily: 'Inter'),
        titleMedium: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w300, fontFamily: 'Inter'),
        labelMedium: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400, fontFamily: 'Inter'),
        labelSmall: TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Inter', fontWeight: FontWeight.w300),
      ),
    ) : ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: Colors.lightGreen,
        onPrimary: Colors.lightGreen[700]!,
        inversePrimary: Colors.lightGreen[900],
        secondary: Colors.white,
        surface: Colors.black,
        tertiary: Color(0xFFEEFAEF),
        error: Colors.white70,
        outline: Colors.white54,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, fontFamily: 'Inter'),
        titleSmall: TextStyle(color: Colors.white60, fontSize: 14, fontWeight: FontWeight.w300, fontFamily: 'Inter'),
        titleMedium: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w300, fontFamily: 'Inter'),
        labelMedium: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400, fontFamily: 'Inter'),
        labelSmall: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Inter', fontWeight: FontWeight.w300),
      ),
    );
  }
}
