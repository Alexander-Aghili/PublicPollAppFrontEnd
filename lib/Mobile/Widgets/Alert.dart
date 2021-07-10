import 'package:flutter/material.dart';
import 'package:public_poll/Controller/Domain.dart';
import 'package:url_launcher/url_launcher.dart';

//Throws an error?
AlertDialog report(BuildContext context, String id, String type) {

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

  return AlertDialog(
    title: Center(
      child: Text("Report", style: TextStyle(color: Colors.red)),
    ),
    content: Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          reportAction("Racist, sexist, or otherwise offensive"),
          reportAction("Promotes violence or other illegal activity"),
          reportAction("Bullying or other harassment"),
          reportAction("False Information"),
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