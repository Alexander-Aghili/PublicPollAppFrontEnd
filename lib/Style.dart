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

  static baseTextStyleWithColor(
      BuildContext context, double fontSize, Color color) {
    return TextStyle(
      color: color,
      /*fontFamily:*/
      fontSize: fontSize * MediaQuery.of(context).textScaleFactor,
    );
  }
}

double getFontSizeHorziontal(BuildContext context, double initSize) {
  Size size = MediaQuery.of(context).size;
  if (size.width < 350) {
    return initSize - 10;
  } else {
    return initSize;
  }
}

double getFontSizeVertical(BuildContext context, double initSize) {
  Size size = MediaQuery.of(context).size;
  if (size.height < 700) {
    return initSize - 10;
  } else {
    return initSize;
  }
}

double getAvatarSize(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  if (size.width < 350) {
    return 32;
  } else if (size.width < 400) {
    return 37;
  } else {
    return 45;
  }
}

double titleSize(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  if (size.width < 300) {
    return 20;
  } else {
    return 35;
  }
}
