import 'package:flutter/material.dart';

class TChipTheme {
  TChipTheme._();

  static final ChipThemeData lightChipTheme = ChipThemeData(
    disabledColor: Colors.grey.withAlpha(4),
    labelStyle: const TextStyle(color: Colors.black),
    selectedColor: Colors.lightBlueAccent,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    checkmarkColor: Colors.white,
  );

  static final ChipThemeData darkChipTheme = ChipThemeData(
    disabledColor: Colors.grey,
    labelStyle: const TextStyle(color: Colors.white),
    selectedColor: Colors.lightBlueAccent,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    checkmarkColor: Colors.white,
  );
}
