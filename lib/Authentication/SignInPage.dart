import 'package:flutter/material.dart';
import 'package:public_poll/Authentication/SignUpPage.dart';

class SignInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignInPage();
}

class _SignInPage extends State<SignInPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController emailController;
  TextEditingController passwordController;
  Size size;

  @override
  initState() {
    emailController = new TextEditingController();
    passwordController = new TextEditingController();
    super.initState();
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool isAppleDevice() {
    return Theme.of(context).platform == TargetPlatform.iOS;
  }

  Widget topText() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: size.height * .025),
      child: Text(
        "Public Poll",
        style: TextStyle(fontSize: 75, color: Colors.black),
      ),
    );
  }

  Widget signInForm() {
    return Form(
      key: _registerFormKey,
      child: Column(
        children: <Widget>[
          signInRow(Icon(Icons.account_circle), "Email", false, emailController,
              null),
          signInRow(
              Icon(Icons.vpn_key), "Password", true, passwordController, null),
        ],
      ),
    );
  }

  Widget signInRow(Icon icon, String inputText, bool secureText,
      TextEditingController controller, Function validator) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8.0),
          height: 75,
          width: 35,
          alignment: Alignment.center,
          child: icon,
        ),
        Container(
          padding: EdgeInsets.all(8.0),
          height: 75,
          width: 350,
          alignment: Alignment.center,
          child: TextFormField(
            obscureText: secureText,
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: inputText,
            ),
            validator: (value) => validator(value),
          ),
        ),
      ],
    );
  }

  Widget signInButton() {
    return Container(
      padding: EdgeInsets.only(top:size.height * .01),
      child: ElevatedButton(
        onPressed: () => null,
        child: Text("Sign in", style: TextStyle(color: Colors.black)),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            minimumSize: MaterialStateProperty.all<Size>(Size(300, 50))),
      ),
    );
  }

  Widget seperateServicesSignInColumn() {
    bool isApple = isAppleDevice();
    double height = 60;
    if (isApple) {
      return Column(
        children: <Widget>[
          SizedBox(
            height: height,
            child: signInWithSeperateServiceButton(AssetImage(
                "assets/images/authbuttons/google_signin_button.png")),
          ),
          SizedBox(
            height: height,
            child: signInWithSeperateServiceButton(AssetImage(
                "assets/images/authbuttons/apple_signin_button.png")),
          ),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          SizedBox(
            height: height,
            child: signInWithSeperateServiceButton(AssetImage(
                "assets/images/authbuttons/google_signin_button.png")),
          ),
        ],
      );
    }
  }

  Widget signInWithSeperateServiceButton(
      /*VoidCallback action,*/ AssetImage image) {
    return GestureDetector(
      onTap: null,
      child: Container(
        width: 270.0,
        height: 65.0,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: image,
        )),
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
      body: Container(
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
                signInForm(),
                signInButton(),
                orContainer(50),
                seperateServicesSignInColumn(),
                signUpButton(context),
                help(),
                Padding(padding: EdgeInsets.only(bottom: size.height*.05)),     
              ],
            ),
          ],
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
}
