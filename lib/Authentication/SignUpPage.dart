import 'package:flutter/material.dart';
import 'package:public_poll/Authentication/SignUpEmailPage.dart';
import 'package:public_poll/Mobile/Widgets/Essential/Header.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>  _SignUpPage();
  
}
class _SignUpPage extends State<SignUpPage> {
  Size size;
  GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();

  @override
  initState() {

    super.initState();
  }

  bool isAppleDevice() {
    return Theme.of(context).platform == TargetPlatform.iOS;
  }

  void dispose() {
    super.dispose();
  }

  Widget topText() {
    return Container(
      child: Text(
        "Sign Up",
        style: TextStyle(fontSize: 75, color: Colors.black),
      ),
    );
  }

  Widget signUpButton() {
    return Container(
      child: ElevatedButton(
        onPressed: () => null,
        child: Text("Sign up", style: TextStyle(color: Colors.black)),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            minimumSize: MaterialStateProperty.all<Size>(Size(300, 50))),
      ),
    );
  }

  Widget appleSignInButton(double height) {
    if (isAppleDevice()) {
      return (SizedBox(
        height: height,
        child: signInWithSeperateServiceButton(
          image: AssetImage("assets/images/authbuttons/apple_signin_button.png"),
          function: null,
        ),
      ));
    }
    return (SizedBox(
      height: height,
    ));
  }

  Widget seperateServicesSignInColumn() {
    double height = 60;
    return Column(
      children: <Widget>[
        SizedBox(
          height: height,
          child: GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpEmailPage())),
            child: serviceButtonContainer(AssetImage("assets/images/authbuttons/email_signin_button.png")),
          ),
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: size.height*.01)),
        SizedBox(
          height: height,
          child: signInWithSeperateServiceButton(
            image: AssetImage("assets/images/authbuttons/google_signin_button.png"),
            function: null,
          ),
        ),
        Padding(padding: EdgeInsets.symmetric(vertical: size.height*.01)),
        appleSignInButton(height),
      ],
    );
  }

  Widget signInWithSeperateServiceButton(
      {Function function, AssetImage image}) {
    return GestureDetector(
      onTap: () => function,
      child: serviceButtonContainer(image),
    );
  }

  Container serviceButtonContainer(AssetImage image) {
    return Container(
      width: 270.0,
      height: 65.0,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: image,
      )),
    );
  }

  Widget orContainer(double height) {
    return Container(
      height: height,
      alignment: Alignment.center,
      child: Text("OR",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25)),
    );
  }

  Widget help() {
    return GestureDetector(
      onTap: null,
      child: Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        width: 100,
        height: 40,
        child: Text(
          "Help",
          style: TextStyle(
              color: Colors.amber,
              decoration: TextDecoration.underline,
              fontSize: 15),
        ),
      ),
    );
  }

  Widget signInButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 50, bottom: 5),
      child: ElevatedButton(
        onPressed: () => Navigator.pop(
            context, MaterialPageRoute(builder: (context) => SignUpPage())),
        child: Text("Sign in", style: TextStyle(color: Colors.black)),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          minimumSize: MaterialStateProperty.all<Size>(Size(300, 50)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
        ),
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.symmetric(vertical: size.height * .035)),
            topText(),
            Spacer(),
            seperateServicesSignInColumn(),
            Spacer(),
            signInButton(context),
            help(),
            Padding(padding: EdgeInsets.only(bottom: size.height*.05)),
          ],
        ),
      ),
    );
  }
}