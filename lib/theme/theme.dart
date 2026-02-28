import 'package:flutter/material.dart';
import 'package:unitime/core/constants/appColors.dart';
import 'package:unitime/theme/app_bar_theme.dart';
import 'package:unitime/theme/bottom_sheet_theme.dart';
import 'package:unitime/theme/checkbox_theme.dart';
import 'package:unitime/theme/chip_theme.dart';
import 'package:unitime/theme/elevated_button_theme.dart';
import 'package:unitime/theme/outlined_button_theme.dart';
import 'package:unitime/theme/text_field_theme.dart';
import 'package:unitime/theme/text_theme.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: const Color.fromRGBO(82, 196, 136, 1),
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primaryColor,
      onPrimary: AppColors.surfaceColor,
      secondary: AppColors.secondaryColor,
      onSecondary: Colors.black,
      onError: AppColors.surfaceColor,
      error: AppColors.errorColor,
      surface: AppColors.surfaceColor,
      onSurface: Colors.black,
      tertiary: AppColors.tertiaryColor,
      onTertiary: AppColors.surfaceColor,
    ),
    textTheme: TTextTheme.lightTextTheme,
    chipTheme: TChipTheme.lightChipTheme,
    checkboxTheme: TCheckBoxTheme.lightCheckBoxTheme,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.LightOutlinedButtonTheme,
    inputDecorationTheme: TTextFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryColor,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primaryColor,
      onPrimary: const Color(0xFFF9FAFB),
      secondary: const Color(0xFF9CA3AF),
      onSecondary: Colors.black,
      onError: AppColors.surfaceColor,
      error: AppColors.errorColor,
      surface: const Color(0xFF111827),
      onSurface: Colors.black,
      tertiary: AppColors.tertiaryColor,
      onTertiary: AppColors.surfaceColor,
    ),
    scaffoldBackgroundColor: Colors.black,
    textTheme: TTextTheme.darkTextTheme,
    chipTheme: TChipTheme.lightChipTheme,
    checkboxTheme: TCheckBoxTheme.darkCheckBoxTheme,
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: TTextFieldTheme.darkInputDecorationTheme,
  );
}
