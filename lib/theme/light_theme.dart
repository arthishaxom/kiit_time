import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: const Color(0xFFFC7012),
    onSurface: const Color(0xff221a15),
    onInverseSurface: const Color(0xFFFFFFFF),
    errorContainer: const Color(0xFFFF3F38),
    onErrorContainer: const Color(0xFFFFFFFF),
    primaryContainer: const Color.fromARGB(255, 255, 114, 19),
    surfaceContainer: const Color.fromARGB(255, 31, 31, 31),
    outline: Colors.grey.shade400,
    surfaceDim: const Color(0xFFFAFAFA),
    onSurfaceVariant: Colors.grey.shade500,
    outlineVariant: Colors.grey.shade100,
    tertiaryContainer: Color.fromARGB(255, 235, 235, 235),
    tertiary: Color.fromARGB(255, 162, 162, 162),
    onPrimaryContainer: Colors.white
  ),
  scaffoldBackgroundColor: const Color(0xFFFFFAF8),
);
