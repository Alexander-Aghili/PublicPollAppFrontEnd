import 'package:flutter/material.dart';
import 'package:public_poll/Mobile/HomePage.dart';
import 'package:public_poll/Mobile/Widgets/Essential/SplashScreen.dart';
import 'package:public_poll/Mobile/Widgets/Essential/Submit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'SignInPage.dart';

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
    String uid = await isLoggedIn();
    if (uid != null && uid != "") {
      return HomePage(uid); //Add UID
    } else {
      return SignInPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    loadEasy();
    return FutureBuilder(
        future: correctPage(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data;
          } else {
            return splashScreen(context);
          }
        });
  }
}
