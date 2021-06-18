import 'package:flutter/material.dart';

errorIcon(double size) {
  return Icon(
    Icons.error,
    size: size,
    color: Colors.red.shade900,
  );
}

errorDisplay() {
  return Container(
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(border: Border.all(color: Colors.black)),
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        errorIcon(100),
        Text(
          "An error occured",
          style: TextStyle(fontSize: 25, color: Colors.red.shade900),
        )
      ],
    ),
  );
}
