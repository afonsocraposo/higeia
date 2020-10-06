import 'package:flutter/material.dart';

class MyColors {
  static const Color mainGreen = Color(0xff39D085);
  static const Color mainBlue = Color(0xff47A0FF);
  static const Color mainPink = Color(0xffDA667B);
  static const Color mainGrey = Color(0xff252422);
  static const Color mainMint = Color(0xffADF1D2);
  static const Color mainOrange = Color(0xffF9A826);

  static const Color lightGrey = Color(0xffF3F3F6);
  static const Color grey = Color(0xFFCCCCCC);

  static MaterialColor greenSwatch = createMaterialColor(mainGreen);

  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }
}
