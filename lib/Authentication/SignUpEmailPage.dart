import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:public_poll/Mobile/Widgets/Essential/Header.dart';

import '../Style.dart';

Size size;
EdgeInsets defaultSignUpPadding() {
  return EdgeInsets.symmetric(
    vertical: size.height * .015,
    horizontal: size.width * .05,
  );
}

/*
  Field Area for each TextFormField, is stored in a list from main page.
*/
class FieldArea extends StatelessWidget {
  final Widget field;

  FieldArea({@required this.field});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: defaultSignUpPadding(),
      child: field,
    );
  }
}

class SignUpEmailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignUpEmailPage();
}

class _SignUpEmailPage extends State<SignUpEmailPage> {
  // ignore: deprecated_member_use
  List<Widget> formFields = List<Widget>();
  DateTime birthday;
  String birthdayString;

  @override
  void initState() {
    super.initState();
    changeBirthday(DateTime.now());

    //First Name Field
    formFields.add(FieldArea(
        field: createField(
            false, new TextEditingController(), "First Name", null)));

    //Last Name Field
    formFields.add(FieldArea(
        field: createField(
            false, new TextEditingController(), "Last Name", null)));

    //Email Form Field
    formFields.add(FieldArea(
        field: createField(false, new TextEditingController(), "Email", null)));

    //Username Form Field
    formFields.add(FieldArea(
        field:
            createField(false, new TextEditingController(), "Username", null)));

    //Password Form Field
    formFields.add(FieldArea(
        field:
            createField(true, new TextEditingController(), "Password", null)));

    //Password confirmation Field
    formFields.add(FieldArea(
        field: createField(
            true, new TextEditingController(), "Password Confirmation", null)));
  }

  TextFormField createField(bool secureText, TextEditingController controller,
      String inputText, Function validator) {
    return TextFormField(
      obscureText: secureText,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: inputText,
      ),
      validator: (value) => validator(value),
    );
  }

  Widget birthdayField() {
    return Container(
      padding: defaultSignUpPadding(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: size.height * .001),
            child: Text(
              "Select Birthday: ",
              style: Styles.baseTextStyleWithColor(
                  context,
                  30,
                  Theme.of(context)
                      .cupertinoOverrideTheme
                      .primaryContrastingColor),
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: size.height * .005)),
          Container(
            height: size.height * .05,
            width: size.width * .75,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: ElevatedButton(
              //This is not gunna work but whatever
              onPressed: () async => {
                if (Platform.isIOS)
                  {iOSBirthdayPicker()}
                else
                  {changeBirthday(await androidBirthdayPicker())}
              },
              child: Text(
                birthdayString,
                style: Styles.baseTextStyleWithColor(
                    context, 30, Theme.of(context).bottomAppBarColor),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context)
                        .cupertinoOverrideTheme
                        .primaryContrastingColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*
  Cupertino style widget for iOS
  */
  void iOSBirthdayPicker() {
    showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
              height: 190,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  Container(
                    height: 180,
                    child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: birthday,
                        onDateTimeChanged: (time) => changeBirthday(time)),
                  ),
                ],
              ),
            ));
  }

  Future androidBirthdayPicker() {
    return showDatePicker(
      context: context,
      initialDate: birthday,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
  }

  Widget genderField() {
    return Container(
      padding: defaultSignUpPadding(),
      alignment: Alignment.center,
      //child: ,
    );
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: header(
        context: context,
        isAppTitle: false,
        title: "Sign Up with Email",
        eliminateBackButton: false,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: ListView(
        physics: const ScrollPhysics(),
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: formFields,
          ),
          birthdayField(),
          genderField(),
        ],
      ),
    );
  }

  void changeBirthday(DateTime newTime) {
    if (newTime == null) return;
    setState(() {
      birthday = newTime;
      birthdayString = (birthday.month.toString() +
          "/" +
          birthday.day.toString() +
          "/" +
          birthday.year.toString());
    });
  }
}
