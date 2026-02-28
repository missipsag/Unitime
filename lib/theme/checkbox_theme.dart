import 'package:flutter/material.dart';

class TCheckBoxTheme {
  TCheckBoxTheme._();

  static final CheckboxThemeData lightCheckBoxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    checkColor: WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.white;
      } else {
        return Colors.black;
      }
    }),
    fillColor: WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.lightBlue;
      } else {
        return Colors.transparent;
      }
    }),
  );


  static final CheckboxThemeData darkCheckBoxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    checkColor: WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.white;
      } else {
        return Colors.black;
      }
    }),
    fillColor: WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.lightBlue;
      } else {
        return Colors.transparent;
      }
    }),
  );
}
