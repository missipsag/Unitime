import 'package:flutter/material.dart';
import 'package:unitime/core/constants/appColors.dart';

class TElevatedButtonTheme {
  TElevatedButtonTheme._();

  static final ElevatedButtonThemeData lightElevatedButtonTheme =
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromRGBO(82, 196, 136, 1),
          disabledForegroundColor: Colors.grey,
          disabledBackgroundColor: Colors.grey,
          side: const BorderSide(color: AppColors.primaryColor),
          padding: const EdgeInsets.symmetric(vertical: 18),
          textStyle: const TextStyle( fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
        ),
      );

  static final ElevatedButtonThemeData darkElevatedButtonTheme = ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromRGBO(82, 196, 136, 1),
          disabledForegroundColor: Colors.grey,
          disabledBackgroundColor: Colors.grey,
          side: const BorderSide(color: AppColors.primaryColor),
          padding: const EdgeInsets.symmetric(vertical: 18),
          textStyle: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
}
