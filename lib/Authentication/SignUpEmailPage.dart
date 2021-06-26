import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:public_poll/Authentication/Validator.dart';
import 'package:public_poll/Controller/UserController.dart';
import 'package:public_poll/Mobile/HomePage.dart';
import 'package:public_poll/Mobile/Widgets/Essential/Header.dart';
import 'package:image_picker/image_picker.dart';
import 'package:public_poll/Models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final TextFormField field;

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

//Main TODO:
//- Fix Other in Gender not remaining
//- Size of Other TextField issue on screen sizes
//- Profile Picture, assetimage vs file and uploading
class _SignUpEmailPage extends State<SignUpEmailPage> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  // ignore: deprecated_member_use
  List<FieldArea> formFields = List<FieldArea>();
  DateTime birthday;
  String birthdayString;
  String gender;
  CircleAvatar avatar;

  @override
  void initState() {
    super.initState();
    changeBirthday(DateTime.now());

    //First Name Field
    formFields.add(FieldArea(
        field: createField(
            false, new TextEditingController(), "First Name", nameValidator)));

    //Last Name Field
    formFields.add(FieldArea(
        field: createField(
            false, new TextEditingController(), "Last Name", nameValidator)));

    //Email Form Field
    formFields.add(FieldArea(
        field: createField(
            false, new TextEditingController(), "Email", emailValidator)));

    //Username Form Field
    formFields.add(FieldArea(
        field: createField(false, new TextEditingController(), "Username",
            usernameValidator)));

    //Password Form Field
    formFields.add(FieldArea(
        field: createField(
            true, new TextEditingController(), "Password", passwordValidator)));

    //Password confirmation Field
    formFields.add(FieldArea(
        field: createField(true, new TextEditingController(),
            "Password Confirmation", passwordValidator)));

    avatar = dynamicAvatar(
        Image.asset("assets/images/default_user_image.jpg").image);
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
          fieldHeader("Select Birthday: "),
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

  //Todo: Finish this field and the rest too
  Widget genderField() {
    TextEditingController otherController = TextEditingController();
    return Container(
      padding: defaultSignUpPadding(),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          fieldHeader("Select Gender: "),
          genderListTile("Male"),
          genderListTile("Female"),
          //Other Selection
          //ToDo: Get this to work
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Other: ",
                  style: Styles.baseTextStyle(context, 30),
                ),
                Container(
                  width: size.width * .5,
                  height: size.height * .015,
                  child: TextField(
                    controller: otherController,
                  ),
                ),
              ],
            ),
            leading: Radio<String>(
                value: otherController.text.toString(),
                groupValue: gender,
                onChanged: (String genderSelected) {
                  print(otherController.text);
                  setState(() {
                    gender = genderSelected;
                  });
                }),
          ),
        ],
      ),
    );
  }

  Widget genderListTile(String genderForListTile) {
    return ListTile(
      title: Text(
        genderForListTile,
        style: Styles.baseTextStyle(context, 30),
      ),
      leading: Radio<String>(
          value: genderForListTile,
          groupValue: gender,
          onChanged: (String genderSelected) {
            setState(() {
              gender = genderSelected;
            });
          }),
    );
  }

  Widget fieldHeader(String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: size.height * .001),
      child: Text(
        text,
        style: Styles.baseTextStyleWithColor(context, 30,
            Theme.of(context).cupertinoOverrideTheme.primaryContrastingColor),
      ),
    );
  }

  Widget profilePictureArea() {
    return Container(
        padding: defaultSignUpPadding(),
        child: GestureDetector(
          onTap: () async {
            File tempImage = await getPicture();
            setState(() {
              avatar = dynamicAvatar(Image.file(tempImage).image);
            });
          },
          child: Container(
            alignment: Alignment.center,
            child: avatar,
          ),
        ));
  }

  CircleAvatar dynamicAvatar(ImageProvider<Object> image) {
    return CircleAvatar(
      backgroundImage: image,
      child: Icon(
        Icons.camera_alt_outlined,
        size: 20,
      ),
      minRadius: 55,
      maxRadius: 55,
    );
  }

  Widget createAccountButton() {
    return Container(
      margin:
          EdgeInsets.only(top: size.height * .05, bottom: size.height * .025),
      padding: EdgeInsets.symmetric(
        horizontal: size.width * .05,
      ),
      width: size.width * .75,
      height: size.height * .05,
      child: ElevatedButton(
        onPressed: () async {
          CreateUser user = CreateUser(
              fields: formFields,
              birthday: birthday,
              gender: gender,
              key: _key,
              context: context);
          bool isValid = await user.validateInfo();
          if (isValid) {
            await user.createPoll();
          }
        },
        child: Text(
          "Create Account",
          style: Styles.baseTextStyle(context, 30),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
        ),
      ),
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
          Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: formFields,
            ),
          ),
          birthdayField(),
          genderField(),
          profilePictureArea(),
          createAccountButton(),
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

  Future<File> getPicture() async {
    PickedFile image =
        // ignore: invalid_use_of_visible_for_testing_member
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    return File(image.path);
  }
}

class CreateUser {
  List<FieldArea> fields;
  /*Key for inputs
  [0] = First Name
  [1] = Last Name
  [2] = Email
  [3] = Username
  [4] = Password
  [5] = Password Confirmation
  */
  //I store in strings as well as list to simplify readability,
  //but can remove if causes issues
  String firstName;
  String lastName;
  String email;
  String username;
  String password;
  String passwordVerify;

  DateTime birthday;
  String gender;

  BuildContext context;
  UserController requests = UserController();
  GlobalKey<FormState> key;

  CreateUser(
      {@required this.fields,
      @required this.birthday,
      @required this.gender,
      @required this.key,
      @required this.context}) {
    List<String> inputs = List<String>();
    for (int i = 0; i < fields.length; i++) {
      inputs.add(fields[i].field.controller.text.toString());
    }
    firstName = inputs[0].trim();
    lastName = inputs[1].trim();
    email = inputs[2].trim();
    username = inputs[3].trim();
    password = inputs[4].trim();
    passwordVerify = inputs[5].trim();
  }

  Future<bool> validateInfo() async {
    Validator.setMessage("");
    //Email or Username in user
    String userInfoValid = await requests.verifyCreateUserInfo(email, username);

    if (userInfoValid != "ok") {
      Validator.setMessage(userInfoValid);
    }

    //Password check
    if (passwordVerify != password) {
      Validator.setMessage("match-passwords");
    }

    //Validate Form
    if (!key.currentState.validate()) return false;

    if (birthday.isAfter(getApprovalDate())) {
      popup(
        "You must be 13 or older to make an account. See our Terms of Service for further details.",
      );
      return false;
    }

    if (gender == "" || gender == null) {
      popup("Please select a gender");
      return false;
    }
    return true;
  }

  DateTime getApprovalDate() {
    return DateTime.now().subtract(Duration(days: (13 * 365)));
  }

  void popup(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              text,
            ),
          );
        });
  }

  Future createPoll() async {
    User user = new User(
        username: username,
        email: email,
        birthday: birthday,
        firstname: firstName,
        lastname: lastName,
        gender: gender,
        password: password,
        profilePictureLink: "");
    String UID = await requests.createUser(user);
    if (UID.isEmpty || UID.indexOf(" ") != -1) {
      popup("Error! Try again.");
    } else {
      //Stay logged in
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString("UID", UID);

      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => HomePage(UID)));
    }
  }
}
