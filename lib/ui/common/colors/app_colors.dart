import 'package:flutter/material.dart';

class AppColors {
  static const List<MaterialColor> palette = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.blueGrey,
  ];

  static MaterialColor getMaterialColor(int colorValue) {
    return palette.firstWhere(
      (mColor) => mColor.toARGB32() == colorValue,
      orElse: () => Colors.grey,
    );
  }

  static int getColorValue(MaterialColor materialColor) {
    return materialColor.toARGB32();
  }
}

