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

      primary: const Color(0xFF52C488),
      onPrimary: const Color(0xFFF9FAFB),
      primaryContainer: const Color(0xFF8dd8b0),
      onPrimaryContainer: const Color.fromARGB(255, 0, 148, 69),

      surface: const Color(0xFF121212),
      onSurface: const Color(0xFFfafafa),
      surfaceContainer:const Color(0xFF363636),
      

      secondary:  const Color(0xFFc6ebd8),
      onSecondary: Color(0xFFF9FAFB),
      secondaryContainer: const Color.fromARGB(255, 159, 207, 181),
      onSecondaryContainer: Color(0xFFF9FAFB) ,

      onError: AppColors.surfaceColor,
      error: AppColors.errorColor,

    ),
    scaffoldBackgroundColor: Color(0xFF121212),
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
