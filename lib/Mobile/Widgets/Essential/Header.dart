import 'package:flutter/material.dart';
import 'package:public_poll/Style.dart';

/*
 * Copyright © 2021 Alexander Aghili - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Alexander Aghili alexander.w.aghili@gmail.com, May 2021
 */

AppBar header({@required context, @required bool isAppTitle, @required String title, @required bool eliminateBackButton,
    Color color}) {
  return AppBar(
    elevation: 1,
    iconTheme: IconThemeData(
      color: Theme.of(context).cupertinoOverrideTheme.primaryContrastingColor,
    ),
    automaticallyImplyLeading: eliminateBackButton ? false : true,
    title: Text(
      (isAppTitle ? "Public Poll" : title),
      style: Styles.baseTextStyle(context, titleSize(context)),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
    backgroundColor: (color == null ? Theme.of(context).primaryColor:color),
  );
}
