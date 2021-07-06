import 'package:flutter/material.dart';
import 'package:public_poll/Authentication/SignInPage.dart';
import 'package:public_poll/Controller/UserController.dart';
import 'package:public_poll/Mobile/Pages/AcountPage/AccountHeader.dart';
import 'package:public_poll/Mobile/Pages/AcountPage/UserPollTab.dart';
import 'package:public_poll/Mobile/Widgets/Essential/Error.dart';
import 'package:public_poll/Mobile/Widgets/Essential/LoadingAction.dart';
import 'package:public_poll/Mobile/Widgets/Essential/MenuItem.dart';
import 'package:public_poll/Models/User.dart';
import 'package:public_poll/url_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

/*
 * Copyright © 2021 Alexander Aghili - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Alexander Aghili alexander.w.aghili@gmail.com, May 2021
 */

class AccountPage extends StatefulWidget {
  String uid;
  AccountPage(this.uid);
  @override
  State<StatefulWidget> createState() => _AccountPage(uid);
}

class _AccountPage extends State<AccountPage> {
  String uid;
  bool isUserAccount;
  Size size;
  _AccountPage(this.uid);

  //URLS
  String reportBugUrl = web_base_url + "/bugReport";
  String contactUsUrl = web_base_url + "/contactUs";

  Future<User> getUserFromID() async {
    UserController userController = UserController();
    isUserAccount = await getHostUserID();
    return await userController.getUserByID(uid);
  }

  Future<bool> getHostUserID() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String tempUID = preferences.getString("UID");
    if (tempUID == uid) {
      return true;
    }
    return false;
  }

  Widget settingsButton() {
    if (!isUserAccount) {
      return Container();
    }
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(right: size.width * .05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          settingsDropdown(),
        ],
      ),
    );
  }

  Widget settingsDropdown() {
    return PopupMenuButton(
      color: Theme.of(context).primaryColor,
      icon: Icon(Icons.settings, size: 30),
      itemBuilder: (context) => <PopupMenuEntry>[
        menuItem(
          0,
          "Edit Account",
          Icon(Icons.account_circle),
          size: size,
          context: context,
        ),
        menuItem(
          1,
          "Report a Bug",
          Icon(Icons.bug_report),
          size: size,
          context: context,
        ),
        menuItem(
          2,
          "Contact Us",
          Icon(Icons.mail),
          size: size,
          context: context,
        ),
        menuItem(3, "Help", Icon(Icons.help), size: size, context: context),
        PopupMenuDivider(),
        menuItem(
            4,
            "Log Out",
            Icon(
              Icons.logout,
              color: Colors.red,
            ),
            color: Colors.red,
            size: size,
            context: context),
      ],
      onSelected: (item) async => {
        if (item == 0)
        {}
        else if (item == 1)
        {
          await canLaunch(reportBugUrl)
              ? launch(reportBugUrl)
              : throw 'Could not launch $reportBugUrl',
        }
        else if (item == 2) 
        {
          await canLaunch(contactUsUrl)
            ? launch(contactUsUrl)
            : throw 'Could not launch $contactUsUrl',
        }
        else if (item == 4)
          {
            await logout(),
          }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: getUserFromID(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User user = snapshot.data;
            return DefaultTabController(
              length: 3,
              child: Scaffold(
                backgroundColor: Theme.of(context).backgroundColor,
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: size.height * .075)),
                    settingsButton(),
                    AccountHeader(user),
                    SizedBox(
                      height: size.height * .125,
                      child: AppBar(
                        backgroundColor: Theme.of(context).backgroundColor,
                        bottom: TabBar(
                          tabs: [
                            Tab(icon: Icon(Icons.save_alt)),
                            Tab(icon: Icon(Icons.remove_red_eye)),
                            Tab(icon: Icon(Icons.create_outlined)),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: <Widget>[
                          UserPollTab(user.savedPollsID),
                          UserPollTab(user.recentlyRespondedToPollsID),
                          UserPollTab(user.myPollsID),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return errorDisplay();
          }
          return SafeArea(
            top: true,
            child: circularProgress(),
          );
        });
  }

  Future logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("UID", "");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignInPage()));
  }
}
