import 'package:flutter/material.dart';

errorIcon(double size) {
  return Icon(
    Icons.error,
    size: size,
    color: Colors.red.shade900,
  );
}

errorDisplay() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        padding: EdgeInsets.all(20),
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
      ),
      FloatingActionButton(
        backgroundColor: Colors.grey,
        child: Icon(Icons.refresh),
        onPressed: () => {},
      ),
    ],
  );
}
