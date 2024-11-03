import 'package:flutter/material.dart';

class AppColor {
  // Light theme colors
  static const _textColorLight = Colors.black;
  static final _bgColorLight = Colors.grey.shade200;
  static const _iconColorLight = Color.fromARGB(255, 67, 61, 61);
  // static const _shodowColordark = Colors.blueAccent;
  static final _chapterBgColorLight =
      const Color.fromARGB(249, 222, 215, 215).withOpacity(0.4);

  // Dark theme colors
  static const _textColorDark = Colors.white70;
  static const _bgColorDark = Color.fromARGB(255, 17, 25, 30);
  static const _iconColorDark = Color.fromARGB(213, 231, 232, 234);
  static const _chapterBgColorDark = Colors.black;

  // Static constants
  static const _appBarWhite = Colors.white;
  static const _appBarBlack = Colors.black;

  // Method to get text color based on the theme
  static Color getTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? _textColorDark
        : _textColorLight;
  }

  // Method to get background color based on the theme
  static Color getBgColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? _bgColorDark
        : _bgColorLight;
  }

  // Method to get icon color based on the theme
  static Color getIconColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? _iconColorDark
        : _iconColorLight;
  }

  static Color getAppBarColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? _appBarBlack
        : _appBarWhite;
  }

  static Color getChepterBgcolor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? _chapterBgColorDark
        : _chapterBgColorLight;
  }

  //  color: const Color.fromARGB(249, 222, 215, 215)
  // .withOpacity(0.4),
}
