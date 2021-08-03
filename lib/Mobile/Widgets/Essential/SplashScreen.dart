import 'package:flutter/material.dart';

splashScreen(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  return Scaffold(
    backgroundColor: Theme.of(context)
        .cupertinoOverrideTheme
        .barBackgroundColor, //Black for dark, white for light
    body: Center(
      child: Container(
        height: size.height * .2,
        width: size.width * .4,
        child: Image(
          image: Image.asset("assets/images/poll_image.png").image,
        ),
      ),
    ),
  );
}
