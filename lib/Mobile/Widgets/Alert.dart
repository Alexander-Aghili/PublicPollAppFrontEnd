import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:public_poll/Controller/Domain.dart';
import 'package:public_poll/Controller/UserController.dart';
import 'package:url_launcher/url_launcher.dart';

//Throws an error?
AlertDialog report(
    BuildContext context, String id, String type, String reportID) {
  Future<void> openLink() async {
    String url = Domain.getWeb() + "report/" + type + "/" + id;
    await launch(url);
    return;
  }

  Widget reportAction(String text, {Future<void> function()}) {
    return InkWell(
      onTap: () async {
        if (function != null) {
          await function();
        } else {
          //Report to backend
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Submitted")),
          );
          Navigator.pop(context);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        width: MediaQuery.of(context).size.width * .75,
        decoration: BoxDecoration(
            border: Border.symmetric(
                horizontal: BorderSide(
                    color: Theme.of(context)
                        .cupertinoOverrideTheme
                        .primaryContrastingColor))),
        child: Text(text, style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Future<void> sendReport() async {
    UserController userController = new UserController();
    await userController.report(reportID, id);
  }

  return AlertDialog(
    title: Center(
      child: Text("Report", style: TextStyle(color: Colors.red)),
    ),
    content: Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          reportAction("Racist, sexist, or otherwise offensive",
              function: sendReport),
          reportAction("Promotes violence or other illegal activity",
              function: sendReport),
          reportAction("Bullying or other harassment", function: sendReport),
          reportAction("False Information", function: sendReport),
          reportAction("Make Detailed Report", function: openLink),
        ],
      ),
    ),
  );
}

void removedSnackBar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Theme.of(context).focusColor,
      content: Text(
        message,
        style: TextStyle(
            color: Theme.of(context)
                .cupertinoOverrideTheme
                .primaryContrastingColor),
      ),
    ),
  );
}

void errorSnackBar(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Theme.of(context).focusColor,
      content: Text(
        message,
        style: TextStyle(
            color: Theme.of(context)
                .cupertinoOverrideTheme
                .primaryContrastingColor),
      ),
    ),
  );
}

void popup(BuildContext context, String text) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            text,
            style: TextStyle(
                color: Theme.of(context)
                    .cupertinoOverrideTheme
                    .primaryContrastingColor),
          ),
        );
      });
}

List<Widget> getButtonWidgets(BuildContext context) {
  return [
    CupertinoButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(
        "Close",
        style: TextStyle(color: Colors.blue),
      ),
    ),
    CupertinoButton(
      onPressed: () {
        AppSettings.openAppSettings();
      },
      child: Text(
        "Settings",
        style: TextStyle(color: Colors.blue),
      ),
    ),
  ];
}

void requestPhotoAccess(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        if (!kIsWeb && Platform.isIOS) {
          return CupertinoAlertDialog(
            title: Text(
              '"Public Poll" cannot access photos.',
              textAlign: TextAlign.center,
            ),
            content: Text(
              "Please change the settings to allow access to the photo library.",
              textAlign: TextAlign.center,
            ),
            actions: getButtonWidgets(context),
          );
        } else {
          return AlertDialog(
            title: Text(
              'Public Poll cannot access photos.',
              textAlign: TextAlign.center,
            ),
            content: Text(
              "Please change the settings to allow access to the photo library.",
              textAlign: TextAlign.center,
            ),
            actions: getButtonWidgets(context),
          );
        }
      });
}

void confirmDelete(BuildContext context, Function deleteFunction) async {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("Are you sure that you want to delete this?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                )),
            content: Text(
              "This cannot be undone",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
            actions: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Spacer(),
                    TextButton(
                        onPressed: () {
                          deleteFunction();
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Delete",
                          style: TextStyle(fontSize: 20, color: Colors.red),
                        ))
                  ],
                ),
              ),
            ]);
      });
}
