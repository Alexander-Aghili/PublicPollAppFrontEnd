import 'package:flutter/material.dart';
import 'LoadingAction.dart';

splashScreen(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  return Scaffold(
    backgroundColor: Theme.of(context)
        .cupertinoOverrideTheme
        .barBackgroundColor, //Black for dark, white for light
    body: Center(
      child: Container(
        height: size.height * .4,
        width: size.width * .4,
        child: Column(
          children: [
            Image(
              image: Image.asset("assets/images/poll_image.png").image,
            ),
            Padding(padding: EdgeInsets.only(top: size.height * .1)),
            circularProgress(),
          ],
        ),
      ),
    ),
  );
}
