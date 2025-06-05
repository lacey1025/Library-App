import 'package:flutter/material.dart';

class AppColors {
  static Color primaryColor = const Color.fromRGBO(
    217,
    0,
    0,
    1,
  ); // red bull red
  static Color primaryAccent = const Color.fromRGBO(120, 14, 14, 1);
  static Color secondaryColor = const Color.fromRGBO(255, 204, 1, 1);
  static Color secondaryAccent = const Color.fromRGBO(
    34,
    31,
    32,
    1,
  ); // army black
  static Color titleColor = const Color.fromRGBO(200, 200, 200, 1);
  static Color armyAccentGrey = const Color.fromRGBO(86, 85, 87, 1);
  static Color textColor = const Color.fromRGBO(150, 150, 150, 1);
  static Color armyGreen = const Color.fromRGBO(47, 55, 47, 1);
  static Color successColor = const Color.fromRGBO(9, 149, 110, 1);
  static Color highlightColor = const Color.fromRGBO(212, 172, 13, 1);
}

ThemeData primaryTheme = ThemeData(
  // seed color theme
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),

  // scaffold color
  scaffoldBackgroundColor: Colors.grey[850],

  // text theme
  textTheme: TextTheme(
    bodyMedium: TextStyle(
      color: Colors.white,
      fontSize: 18,
      height: 1.2,
      fontFamily: "GI",
      overflow: TextOverflow.ellipsis,
    ),
    bodySmall: TextStyle(
      color: Colors.white,
      fontSize: 18,
      height: 1.2,
      fontWeight: FontWeight.w300,
      fontFamily: "GI",
      overflow: TextOverflow.ellipsis,
    ),
    headlineMedium: TextStyle(
      color: Colors.white,
      fontFamily: 'GI',
      fontWeight: FontWeight.w700,
      fontSize: 20,
      height: 1.2,
      overflow: TextOverflow.ellipsis,
    ),
    titleMedium: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontFamily: "GI",
      fontWeight: FontWeight.w700,
    ),
    titleLarge: TextStyle(
      color: Colors.white,
      fontFamily: 'GI',
      fontWeight: FontWeight.w700,
      fontSize: 26,
    ),
  ),

  // app bar theme colors
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.secondaryAccent,
    foregroundColor: Colors.white,
    surfaceTintColor: Colors.transparent,
  ),

  cardTheme: CardTheme(
    color: Colors.grey[800],
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    margin: const EdgeInsets.only(bottom: 12),
    elevation: 5,
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[800],
    labelStyle: TextStyle(color: Colors.white),
    errorStyle: TextStyle(color: Colors.red[600]),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: const Color.fromRGBO(229, 57, 53, 1)),
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: const Color.fromRGBO(229, 57, 53, 1)),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: Colors.white),
  ),
  dialogTheme: DialogTheme(
    backgroundColor: Colors.grey[800],
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontFamily: 'GI',
      fontWeight: FontWeight.w700,
      fontSize: 24,
    ),
    contentTextStyle: TextStyle(
      color: Colors.white,
      fontFamily: 'GI',
      fontWeight: FontWeight.w700,
      fontSize: 18,
    ),
  ),

  dividerTheme: DividerThemeData(
    color: Colors.grey[700],
    thickness: 1,
    indent: 0,
    endIndent: 0,
  ),
);
