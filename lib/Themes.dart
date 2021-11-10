import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*
 * Copyright © 2021 Alexander Aghili - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Alexander Aghili alexander.w.aghili@gmail.com, May 2021
 */

/*
ToDo: Fix the colors of the TextFields
*/

ThemeData darkMode() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  return ThemeData(
    brightness: Brightness.dark,
    cupertinoOverrideTheme: CupertinoThemeData(
        barBackgroundColor: Colors.black,
        primaryColor: CupertinoColors.activeOrange,
        primaryContrastingColor: Colors.white),
    backgroundColor: Color(0xff141414),
    primaryColor: Colors.black,
    hintColor: Colors.white,
    dialogTheme: DialogTheme(
      contentTextStyle: TextStyle(fontSize: 25),
    ),
    focusColor: Colors.grey.shade800,
    accentColor: Colors.grey.shade300,
    textSelectionTheme: darkModeTextSelectionTheme(),
  );
}

TextSelectionThemeData darkModeTextSelectionTheme() {
  return TextSelectionThemeData(
    cursorColor: Colors.white,
  );
}

ThemeData lightMode() {
  return ThemeData(
    brightness: Brightness.light,
    cupertinoOverrideTheme: CupertinoThemeData(
      barBackgroundColor: Colors.white10,
      primaryColor: CupertinoColors.darkBackgroundGray,
      primaryContrastingColor: Colors.black,
    ),
    backgroundColor: Colors.white,
    primaryColor: Colors.white,
    hintColor: Colors.black,
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(color: Colors.black),
      labelStyle: TextStyle(color: Colors.black),
      focusColor: Colors.black,
      focusedBorder: OutlineInputBorder(
        borderSide:  BorderSide(width: 1, color: Colors.black),
      )
    ),
    focusColor: Colors.grey.shade300,
    accentColor: Colors.grey.shade800,
    textSelectionTheme: lightModeTextSelectionTheme(),
    dialogTheme: DialogTheme(
      contentTextStyle: TextStyle(fontSize: 25),
    ),
  );
}

TextSelectionThemeData lightModeTextSelectionTheme() {
  return TextSelectionThemeData(
    cursorColor: Colors.black,
  );
}
