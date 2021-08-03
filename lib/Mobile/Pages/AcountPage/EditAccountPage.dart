import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:public_poll/Authentication/Validator.dart';
import 'package:public_poll/Controller/UserController.dart';
import 'package:public_poll/Mobile/Widgets/Essential/Avatar.dart';
import 'package:public_poll/Mobile/Widgets/Essential/Header.dart';
import 'package:public_poll/Mobile/Widgets/FormFields.dart';
import 'package:public_poll/Models/KeyValue.dart';
import 'package:public_poll/Models/User.dart';

//TODO: Do
class EditAccountPage extends StatefulWidget {
  final User user;

  EditAccountPage(this.user);

  @override
  State<StatefulWidget> createState() => _EditAccountPage(user);
}

class _EditAccountPage extends State<EditAccountPage> {
  User user;
  Size size;
  File profileFile;
  Image profileImage;
  Image originalImage;
  bool savePressed = false;
  List<FieldArea> formFields = List<FieldArea>.empty(growable: true);

  _EditAccountPage(this.user);

  @override
  void initState() {
    super.initState();
    originalImage = getAvatarForAccount();
    profileImage = originalImage;
  }

  GlobalKey<FormState> _key = GlobalKey<FormState>();

  Padding defaultPadding() {
    return Padding(padding: EdgeInsets.only(bottom: 20));
  }

  Widget changeDetails() {
    return Form(
      key: _key,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: formFields,
      ),
    );
  }

  Widget profilePicture(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        PickedFile file =
            await ImagePicker.platform.pickImage(source: ImageSource.gallery);
        setState(() {
          profileFile = File(file.path);
          profileImage = Image.file(profileFile);
        });
      },
      child: getAvatar(profileImage, 45, true),
    );
  }

  Image getAvatarForAccount() {
    Image avatar;
    if (user.profilePictureLink == null || user.profilePictureLink == "") {
      avatar = Image.asset("assets/images/default_user_image.jpg");
    } else {
      return user.profilePicture;
    }
    return avatar;
  }

  Widget saveDetails() {
    return Container(
      width: size.width * .75,
      child: ElevatedButton(
        onPressed: () async => editUser(),
        child: Text(
          "Save",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget deleteAccount() {
    return Container(
      width: size.width * .75,
      child: ElevatedButton(
        onPressed: () {},
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(child: Icon(Icons.delete_forever)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * .01),
              child: Text(
                "Delete Account",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        style:
            ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    if (formFields.isEmpty) {
      //First Name Field
      formFields.add(FieldArea(size,
          field: createField(
              false, new TextEditingController(), "First Name", nameValidator,
              initialText: user.firstname)));

      //Last Name Field
      formFields.add(FieldArea(size,
          field: createField(
              false, new TextEditingController(), "Last Name", nameValidator,
              initialText: user.lastname)));

      //Username Form Field
      formFields.add(FieldArea(size,
          field: createField(
              false, new TextEditingController(), "Username", usernameValidator,
              initialText: user.username)));
    }
    return Scaffold(
      backgroundColor:
          Theme.of(context).cupertinoOverrideTheme.barBackgroundColor,
      appBar: header(
          context: context,
          isAppTitle: false,
          title: "Edit Account",
          eliminateBackButton: false),
      body: ListView(
        physics: const ScrollPhysics(),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              changeDetails(),
              defaultPadding(),
              profilePicture(context),
              defaultPadding(),
              saveDetails(),
              for (int i = 0; i < 3; i++) defaultPadding(),
              deleteAccount(),
            ],
          ),
        ],
      ),
    );
  }

  Future editUser() async {
    if (savePressed) {
      return;
    } else {
      setState(() {
        savePressed = true;
      });
    }

    List<KeyValue> keyValuePairs = new List<KeyValue>.empty(growable: true);
    List<KeyValue> editValues = new List<KeyValue>.empty(growable: true);

    String firstname = formFields[0].field.controller.text.toString().trim();
    String lastname = formFields[1].field.controller.text.toString().trim();
    String username = formFields[2].field.controller.text.toString().trim();

    if (firstname != user.firstname) {
      keyValuePairs.add(new KeyValue("firstname", firstname));
    }
    if (lastname != user.lastname) {
      keyValuePairs.add(new KeyValue("lastname", lastname));
    }
    if (username != user.username) {
      keyValuePairs.add(new KeyValue("username", username));
    }

    UserController controller = UserController();
    _key.currentState.validate();

    if (keyValuePairs.isNotEmpty)
      editValues.add(new KeyValue("user", true));
    else
      editValues.add(new KeyValue("user", false));

    if (keyValuePairs.length > 0) {
      String response =
          await controller.editUserInformation(user.userID, keyValuePairs);
      if (response == "error") {
        print("error"); // debug
      } else if (response == "usernameExists") {
        Validator.setMessage("username");
        return;
      }
    }
    _key.currentState.validate();

    if (profileImage != originalImage) {
      editValues.add(new KeyValue("image", profileImage));
      bool needReplaceUrl;

      if (user.profilePictureLink
              .substring(user.profilePictureLink.lastIndexOf("/") + 1) ==
          (user.userID.toString() + '-profileImage.jpg')) {
        needReplaceUrl = false;
      } else {
        needReplaceUrl = true;
      }
      await controller.uploadProfileImage(
          profileFile, user.userID, needReplaceUrl);
    } else {
      editValues.add(new KeyValue("image", ""));
    }
    Navigator.pop(context, editValues);
  }
}
