import 'package:flutter/material.dart';

class TTextTheme {
  TTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.black
    ),
    headlineMedium: const TextStyle().copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.black
    ),
    bodyMedium: const TextStyle().copyWith(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    bodySmall:  const TextStyle().copyWith(
      fontSize: 13,
      fontWeight: FontWeight.normal,
      color: Colors.grey,
    ),

    labelLarge: const TextStyle().copyWith(
      fontSize: 11,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),

    labelMedium: const TextStyle().copyWith(
      fontSize: 11,
      fontWeight: FontWeight.normal,
      color: Colors.black.withAlpha(5),
    ),

  );

  static TextTheme darkTextTheme = TextTheme(
     headlineLarge: const TextStyle().copyWith(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headlineMedium: const TextStyle().copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    bodyMedium: const TextStyle().copyWith(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    bodySmall: const TextStyle().copyWith(
      fontSize: 13,
      fontWeight: FontWeight.normal,
      color: Colors.grey,
    ),
  labelLarge: const TextStyle().copyWith(
      fontSize: 11,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),

    labelMedium: const TextStyle().copyWith(
      fontSize: 11,
      fontWeight: FontWeight.normal,
      color: Colors.white.withAlpha(5),
    ),

  );
}
