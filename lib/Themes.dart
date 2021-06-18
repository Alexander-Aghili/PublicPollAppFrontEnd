import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/*
 * Copyright © 2021 Alexander Aghili - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Alexander Aghili alexander.w.aghili@gmail.com, May 2021
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
      backgroundColor: Colors.pink.shade100,
      primaryColor: Colors.white,
      hintColor: Colors.black,
      dialogTheme: DialogTheme(
        backgroundColor: Colors.blue,
      ),
    );
}
