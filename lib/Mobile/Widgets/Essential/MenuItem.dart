import 'package:flutter/material.dart';

import '../../../Style.dart';

PopupMenuItem<int> menuItem(int value, String text, Icon icon,
      {Color color, @required Size size, @required BuildContext context, bool extraPadding}) {
    
    return PopupMenuItem<int>(
      value: value,
      child: Row(
        children: <Widget>[
          if (extraPadding != null && extraPadding != false)
            Padding(padding: EdgeInsets.only(right: 5)),

          Container(
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