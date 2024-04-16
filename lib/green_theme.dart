import 'package:flutter/material.dart';

Color green5 = const Color(0xFF014421);
Color green4 = const Color(0xFF355E3B);
Color green3 = const Color(0xFF379683);
Color green2 = const Color(0xFF5CDB95);
Color green1 = const Color(0xFF8EE4AF);
Color blanc2 = const Color(0xFFBCB88A);
Color blanc1 = const Color(0xFFD1FACE);

ThemeData greenTheme = ThemeData(
  appBarTheme: AppBarTheme(
    color: green5,
    shadowColor: green2,
    elevation: 5,
    foregroundColor: blanc2,
  ),
  colorScheme: ColorScheme.fromSeed(
    background: green4,
    seedColor: green1,
    brightness: Brightness.light,
    error: green2,
  ),
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
      elevation: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered)) {
          return 5.0;
        } else {
          return 3.0;
        }
      }),
      backgroundColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered)) {
          return blanc1;
        } else {
          return green5;
        }
      }),
      shadowColor: MaterialStateProperty.all<Color>(Colors.lightGreenAccent),
      foregroundColor: MaterialStateProperty.resolveWith(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            return green5;
          } else {
            return blanc1;
          }
        },
      ),
    ),
  ),
);
