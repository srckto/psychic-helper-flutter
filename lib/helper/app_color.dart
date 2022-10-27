import 'package:flutter/material.dart';

class AppColors {
  static const grayColor = Color(0xFF515C6F);

  static final fontGrayColor = grayColor.withOpacity(0.5);

  static const canvasColor = Color(0xFFF5F6F8);

  static const red = Colors.red;

  static const black = Colors.black;

  static const green = Colors.green;

  static const brown = Colors.brown;

  static const _primaryColorValue = 0xFFFF6969;

  static const MaterialColor primaryColor = MaterialColor(
    _primaryColorValue,
    <int, Color>{
      50: Color(0xFF000000),
      100: Color(0xFF000000),
      200: Color(0xFF000000),
      300: Color(0xFF000000),
      400: Color(0xFF000000),
      500: Color(_primaryColorValue),
      600: Color(0xFF000000),
      700: Color(0xFF000000),
      800: Color(0xFF000000),
      900: Color(0xFF000000),
    },
  );
}
