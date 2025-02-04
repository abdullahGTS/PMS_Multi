import 'package:flutter/material.dart';

class Themes {
  static ThemeData lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromRGBO(18, 47, 81, 0.9),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color.fromRGBO(18, 47, 81, 0.9),
    ),
    scaffoldBackgroundColor: const Color.fromRGBO(219, 214, 204, 1),
  );
  static ThemeData darkTheme = ThemeData.dark();
}
