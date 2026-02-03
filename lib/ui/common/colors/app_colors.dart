

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
  static MaterialColor getMaterialColor(Color color) {
    return AppColors.palette.firstWhere(
          (mColor) => mColor.value == color.value,
      orElse: () => Colors.grey, // Fallback
    );
  }
}

/*
// To DB
final colorInt = entity.color.value;

// From DB
final color = Color(result.colorValue);
 */