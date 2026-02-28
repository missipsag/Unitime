import 'package:flutter/material.dart';
import 'package:unitime/core/constants/appColors.dart';

class TTextFieldTheme {
  TTextFieldTheme._();

  static final InputDecorationTheme
  lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: Colors.grey,
    suffixIconColor: Colors.grey,
    // constraint : const BoxConstraints.expand(height : 14.inputFieldHeight)
    labelStyle: const TextStyle().copyWith(fontSize: 14, color: Colors.black),
    hintStyle: const TextStyle().copyWith(fontSize: 14, color: Colors.black),
    errorStyle: TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(
      color: Colors.black.withAlpha(8),
    ),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: Colors.grey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: Colors.black12),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: Colors.grey),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: AppColors.errorColor),
    ),

    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: Colors.deepOrange),
    ),
  );

  static final InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: Colors.grey,
    suffixIconColor: Colors.grey,
    // constraint : const BoxConstraints.expand(height : 14.inputFieldHeight)
    labelStyle: const TextStyle().copyWith(fontSize: 14, color: Colors.white),
    hintStyle: const TextStyle().copyWith(fontSize: 14, color: Colors.white),
    errorStyle: TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(
      color: Colors.black.withAlpha(8),
    ),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: Colors.grey),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: Colors.white),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: Colors.grey),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: AppColors.errorColor),
    ),

    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: Colors.deepOrange),
    ),
  );
}
