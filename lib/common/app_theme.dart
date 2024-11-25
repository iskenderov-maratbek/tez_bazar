import 'package:flutter/material.dart';

ThemeData themeData(BuildContext context) {
  double borderRadius = 50;
  double borderSize = 3;
  return ThemeData(
    fontFamily: 'MiSans',
    // pageTransitionsTheme: PageTransitionsTheme(
    //   builders: {
    //     TargetPlatform.android: CustomTransition(),
    //     TargetPlatform.iOS: CustomTransition(),
    //     TargetPlatform.macOS: CustomTransition(),
    //     TargetPlatform.windows: CustomTransition(),
    //   },
    // ),
    segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
      foregroundColor: WidgetStateProperty.all<Color>(const Color(0xFFFBC02D)),
    )),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
      ),
    ),
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
        borderSide: BorderSide(color: Colors.purple, width: borderSize),
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
      style: ElevatedButton.styleFrom(
        // backgroundColor: Colors.yellow[700],
        // foregroundColor: Colors.black,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStateProperty.all<Color>(
            const Color.fromARGB(255, 255, 255, 255)),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            side: const BorderSide(color: Color.fromARGB(0, 251, 193, 45)),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        backgroundColor:
            WidgetStateProperty.resolveWith((Set<WidgetState> state) {
          if (state.contains(WidgetState.pressed)) {
            return Colors.grey[700];
          } else if (state.contains(WidgetState.selected)) {
            return const Color.fromARGB(0, 0, 0, 0);
          }
          return  const Color.fromRGBO(156, 39, 176, 1);
        }),
      ),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Colors.black,
      surfaceTintColor: Colors.transparent,
    ),
  );
}
