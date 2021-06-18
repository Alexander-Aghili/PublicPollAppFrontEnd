import 'package:flutter/material.dart';

/*
 * Copyright © 2021 Alexander Aghili - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Alexander Aghili alexander.w.aghili@gmail.com, May 2021
 */

class Styles {
  static baseTextStyle(BuildContext context, double fontSize) {
    return TextStyle(
      color: Theme.of(context).cupertinoOverrideTheme.primaryContrastingColor,
      /*fontFamily:*/
      fontSize: fontSize * MediaQuery.of(context).textScaleFactor,
    );
  }
  static baseTextStyleWithColor(BuildContext context, double fontSize, Color color) {
    return TextStyle(
      color: color,
      /*fontFamily:*/
      fontSize: fontSize * MediaQuery.of(context).textScaleFactor,
    );
  }
}
