import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: Color.fromARGB(255, 255, 132, 51),
    onSurface: Color.fromARGB(255, 244, 244, 244),
    onInverseSurface: Color.fromARGB(255, 44, 44, 44),
    errorContainer: Color.fromARGB(255, 255, 83, 77),
    onErrorContainer: const Color(0xFFFFFFFF),
    primaryContainer: Color.fromARGB(255, 255, 129, 45),
    surfaceContainer: Color.fromARGB(255, 232, 232, 232),
    outline: Colors.grey.shade700,
    surfaceDim: Color.fromARGB(255, 52, 52, 52),
    onSurfaceVariant: Colors.grey.shade700,
    outlineVariant: Colors.grey.shade800,
    tertiaryContainer: const Color.fromARGB(255, 35, 35, 35),
    tertiary: Color.fromARGB(255, 112, 112, 112),
    onPrimaryContainer: Colors.white
  ),
  scaffoldBackgroundColor: Color.fromARGB(255, 38, 36, 36),
);
