import 'package:flutter/material.dart';

class Tcolor {
  static Color get primary => const Color(0xff334D53);
  static Color get primary2 => const Color(0xff6899A4);
  static Color get secondary => const Color(0xffAB3527);
  static Color get secondary2 => const Color(0xff812115);
  static Color get primary3 => const Color(0xffC2EAF3);
  static Color get secondary5 => const Color(0xff474E43);
  static Color get secondary6 => const Color(0xffB6C6AE);
  static Color get secondary3 => const Color(0xffD1A19C);
  static Color get secondary4 => const Color(0xff581911);
  static List<Color> get primaryG => [primary, primary2, primary3];
  static List<Color> get secondaryG => [
    secondary,
    secondary2,
    secondary3,
    secondary4,
    secondary5,
    secondary6,
  ];
  static Color get white => const Color.fromARGB(255, 255, 255, 255);
  static Color get black => const Color.fromARGB(255, 0, 0, 0);
  static Color get grey => const Color.fromARGB(255, 158, 158, 158);
  static Color get lightGrey => const Color.fromARGB(255, 224, 224, 224);
  static Color get darkGrey => const Color.fromARGB(255, 117, 117, 117);
}
