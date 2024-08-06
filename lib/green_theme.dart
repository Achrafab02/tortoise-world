import 'package:flutter/material.dart';

Color green5 = const Color(0xFF014421);
Color green4 = const Color(0xFF355E3B);
Color green3 = const Color(0xFF379683);
Color green2 = const Color(0xFF5CDB95);
Color green1 = const Color(0xFF8EE4AF);
Color blanc2 = const Color(0xFFBCB88A);
Color blanc1 = const Color(0xFFD1FACE);

ThemeData greenTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
    color: green5,
    shadowColor: green2,
    elevation: 5,
    foregroundColor: blanc2,
  ),
  colorSchemeSeed: green1,
  scaffoldBackgroundColor: green4,
  textTheme:  TextTheme(
    bodyLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: blanc2),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: blanc2),
  ),
  dialogTheme: DialogTheme(
    backgroundColor: blanc1,
    surfaceTintColor: blanc1,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      elevation: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.hovered)) {
          return 5.0;
        } else {
          return 3.0;
        }
      }),
      backgroundColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.hovered)) {
          return blanc1;
        } else {
          return green5;
        }
      }),
      shadowColor: WidgetStateProperty.all<Color>(Colors.lightGreenAccent),
      foregroundColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.hovered)) {
            return green5;
          } else {
            return blanc1;
          }
        },
      ),
    ),
  ),
);
