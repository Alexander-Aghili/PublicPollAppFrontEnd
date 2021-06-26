import 'package:flutter/material.dart';

import '../../../Style.dart';

PopupMenuItem<int> menuItem(int value, String text, Icon icon,
      {Color color, @required Size size, @required BuildContext context}) {
    return PopupMenuItem<int>(
      value: value,
      child: Row(
        children: <Widget>[
          Container(
            width: size.width * .25,
            child: Text(
              text,
              style: (color == null
                  ? Styles.baseTextStyle(context, 25)
                  : Styles.baseTextStyleWithColor(context, 25, color)),
            ),
          ),
          Spacer(),
          icon,
        ],
      ),
    );
  }