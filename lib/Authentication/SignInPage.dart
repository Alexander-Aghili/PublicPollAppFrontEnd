import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:public_poll/Authentication/SignUpPage.dart';
import 'package:public_poll/Controller/UserController.dart';
import 'package:public_poll/Mobile/HomePage.dart';
import 'package:public_poll/Style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignInPage();
}

class _SignInPage extends State<SignInPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController usernameController;
  TextEditingController passwordController;
  Size size;
  Container errorDisplay;
  bool absorb;

  @override
  initState() {
    usernameController = new TextEditingController();
    passwordController = new TextEditingController();
    absorb = false;
    errorDisplay = errorContainer("ok");
    super.initState();
  }

  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool isAppleDevice() {
    return Theme.of(context).platform == TargetPlatform.iOS;
  }

  Widget topText() {
    double fontSize;
    if (size.width < 375) {
      fontSize = 55;
    } else {
      fontSize = 75;
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: size.height * .025),
      child: Text(
        "Public Poll",
        style: TextStyle(fontSize: fontSize, color: Colors.black),
      ),
    );
  }

  Container errorContainer(String information) {
    Text text = Text("");
    if (information == "info error") {
      text = Text(
        "Incorrect username or password",
        style: Styles.baseTextStyleWithColor(context, 20, Colors.red),
      );
    } else if (information == "regular error") {
      text = Text(
        "System error, retry.",
        style: Styles.baseTextStyleWithColor(context, 20, Colors.red),
      );
    }
    return Container(
      child: text,
    );
  }

  Widget signInForm() {
    return Form(
      key: _registerFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          signInRow(Icon(Icons.account_circle), "Username", false,
              usernameController),
          signInRow(Icon(Icons.vpn_key), "Password", true, passwordController),
          forgetPassword(),
        ],
      ),
    );
  }

  Widget signInRow(Icon icon, String inputText, bool secureText,
      TextEditingController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8.0),
          height: 75,
          width: size.width * .85,
          alignment: Alignment.center,
          child: TextFormField(
            obscureText: secureText,
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: icon,
              border: OutlineInputBorder(),
              labelText: inputText,
            ),
          ),
        ),
      ],
    );
  }

  Widget forgetPassword() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.only(left: 8),
      width: size.width * .85,
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Forgot Password?", style: TextStyle(fontSize: 20),),
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Enter your email to reset your password."),
                        TextField(
                          
                        ),
                      ],
                    ),
                  );
                });
          },
          child: Text(
            "Forgot Password",
            style: TextStyle(fontSize: 12, color: Colors.blue.shade100),
          ),
        ),
      ),
    );
  }

  Widget signInButton() {
    return Container(
      padding: EdgeInsets.only(top: size.height * .01),
      child: ElevatedButton(
        onPressed: () async => await signIn(),
        child: Text("Sign in", style: TextStyle(color: Colors.black)),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            minimumSize: MaterialStateProperty.all<Size>(Size(300, 50))),
      ),
    );
  }

  Widget seperateServicesSignInColumn() {
    bool isApple = isAppleDevice();
    SignIn signIn = SignIn();
    double height = 60;
    if (isApple) {
      return Column(
        children: <Widget>[
          SizedBox(
            height: height,
            child: signInWithSeperateServiceButton(
                null,
                AssetImage(
                    "assets/images/authbuttons/google_signin_button.png")),
          ),
          SizedBox(
            height: height,
            child: signInWithSeperateServiceButton(
                signIn.signInWithApple,
                AssetImage(
                    "assets/images/authbuttons/apple_signin_button.png")),
          ),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          SizedBox(
            height: height,
            child: signInWithSeperateServiceButton(
                null,
                AssetImage(
                    "assets/images/authbuttons/google_signin_button.png")),
          ),
        ],
      );
    }
  }

  Widget signInWithSeperateServiceButton(Function function, AssetImage image) {
    return InkWell(
      child: GestureDetector(
        onTap: () => function(),
        child: Container(
          width: 270.0,
          height: 65.0,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: image,
          )),
        ),
      ),
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

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: AbsorbPointer(
        absorbing: absorb,
        child: Container(
          decoration: BoxDecoration(color: Colors.grey),
          alignment: Alignment.topCenter,
          child: ListView(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  topText(),
                  errorDisplay,
                  signInForm(),
                  signInButton(),
                  orContainer(50),
                  seperateServicesSignInColumn(),
                  signUpButton(context),
                  help(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget signUpButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 50, bottom: 5),
      child: ElevatedButton(
        onPressed: () => Navigator.push(
            //Fix navigator
            context,
            MaterialPageRoute(builder: (context) => SignUpPage())),
        child: Text("Sign up", style: TextStyle(color: Colors.black)),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          minimumSize: MaterialStateProperty.all<Size>(Size(300, 50)),
        ),
      ),
    );
  }

  Future signIn() async {
    if (EasyLoading.isShow) return;
    setState(() {
      absorb = true;
    });
    EasyLoading.show();
    SignIn signIn = SignIn(
        username: usernameController.text, password: passwordController.text);
    String uid = await signIn.sendSignInRequest();
    //Error container says bad username or password
    if (uid.isNotEmpty && uid.indexOf(" ") == -1) {
      //Saving logged
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString("UID", uid);
      EasyLoading.dismiss();
      setState(() {
        absorb = false;
      });
      //Going to push with User information
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => HomePage(uid)));
    } else {
      EasyLoading.dismiss();
      setState(() {
        absorb = false;
        errorDisplay = errorContainer(uid);
      });
    }
  }
}

class SignIn {
  String username;
  String password;

  SignIn({this.username, this.password});

  Future<String> sendSignInRequest() async {
    UserController request = UserController();
    return await request.signInWithUsernameAndPassword(
        username.trim(), password.trim());
  }

  Future signInWithApple() async {
    final credential = SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    print(credential);
  }
}
