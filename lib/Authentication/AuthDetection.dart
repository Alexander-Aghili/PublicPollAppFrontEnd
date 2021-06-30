import 'package:flutter/material.dart';
import 'package:public_poll/Mobile/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SignInPage.dart';
//TODO: Get better intro screen
class AuthDetection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AuthDetection();
}

class _AuthDetection extends State<AuthDetection> {

  //Checks if user is logged in
  Future<String> isLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("UID");
  }

  Future<Widget> correctPage() async {
    String UID = await isLoggedIn();
    if (UID != null && UID != "") {
      return HomePage(UID); //Add UID
    } else {
      return SignInPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: correctPage(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data;
          } else {
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
        });
  }
}
