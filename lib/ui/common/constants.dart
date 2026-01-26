import 'package:flutter/cupertino.dart';

class Constants {
  static const mainPageHorizontalPadding = 8.0;
  static const habitsSep = 2.0;
  static const habitsPerRow = 4;

  static double habitWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return ((screenWidth - 2 * mainPageHorizontalPadding) / habitsPerRow) -
        2 * habitsSep;
  }
}
