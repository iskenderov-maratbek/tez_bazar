import 'package:flutter/material.dart';

ThemeData themeData(BuildContext context) {
  double borderRadius = 50;
  double borderSize = 3;
  return ThemeData(
    fontFamily: 'Inter',
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.purple,
      selectionColor: Colors.blue,
      selectionHandleColor: Colors.purple,
    ),
    scaffoldBackgroundColor: Colors.black,
    inputDecorationTheme: InputDecorationTheme(
      prefixStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      hintStyle: const TextStyle(color: Colors.grey),
      suffixIconColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent, width: borderSize),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent, width: borderSize),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueAccent, width: borderSize),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red[700]!, width: borderSize),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red[700]!, width: borderSize),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Colors.black,
      surfaceTintColor: Colors.transparent,
    ),
  );
}
