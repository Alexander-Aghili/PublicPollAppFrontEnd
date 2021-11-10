import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:public_poll/Authentication/SignInPage.dart';
import 'package:public_poll/Controller/Domain.dart';
import 'package:public_poll/Controller/PollRequests.dart';
import 'package:public_poll/Controller/UserController.dart';
import 'package:public_poll/Mobile/Pages/AcountPage/AccountHeader.dart';
import 'package:public_poll/Mobile/Pages/AcountPage/EditAccountPage.dart';
import 'package:public_poll/Mobile/Pages/AcountPage/UserPollTab.dart';
import 'package:public_poll/Mobile/Widgets/Essential/LoadingAction.dart';
import 'package:public_poll/Mobile/Widgets/Essential/MenuItem.dart';
import 'package:public_poll/Models/KeyValue.dart';
import 'package:public_poll/Models/Poll.dart';
import 'package:public_poll/Models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

/*
 * Copyright © 2021 Alexander Aghili - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Alexander Aghili alexander.w.aghili@gmail.com, May 2021
 */

class AccountPage extends StatefulWidget {
  final User user;
  final String hostuid;
  final Function updateAccountInfo;
  AccountPage(this.user, this.hostuid, this.updateAccountInfo);
  @override
  State<StatefulWidget> createState() =>
      _AccountPage(user, hostuid, updateAccountInfo);
}

class _AccountPage extends State<AccountPage> {
  String hostuid;
  Size size;
  Image profileImage;
  User user;
  Function updateAccountInfo;
  bool isUserAccount;
  bool backButton;
  _AccountPage(this.user, this.hostuid, this.updateAccountInfo) { 
    isUserAccount = (hostuid == user.userID);
  }

  List<KeyValue> userPollInfo = new List<KeyValue>.empty(growable: true);
  Future userPollData;

  List<Poll> savedPolls;
  List<Poll> recentlyRespondedToPolls;
  List<Poll> myPolls;

  //URLS
  String reportBugUrl = Domain.getWeb() + "reportBug";
  String contactUsUrl = Domain.getWeb() + "contactUs";
  String helpUrl = Domain.getWeb() + "help";

  @override
  void initState() {
    super.initState();
    userPollData = userPollFuture(user.userID);
    if (EasyLoading.isShow) EasyLoading.dismiss();
  }

  Future updateUser(List<KeyValue> editValues) async {
    User tmpUser = await updateAccountInfo();
    setState(() {
      user = tmpUser;
      if (editValues[1].value != "") {
        user.profilePicture = editValues[1].value;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Information Updated")),
    );
  }

  Widget settingsButton() {
    if (!isUserAccount) {
      return Container();
    }
    return Container(
      alignment: Alignment.center,
      //margin: EdgeInsets.only(right: size.width * .05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          settingsDropdown(user),
        ],
      ),
    );
  }

  Widget settingsDropdown(User user) {
    List<KeyValue> editValues = new List<KeyValue>.empty(growable: true);
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
          {
            editValues = await Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => EditAccountPage(user))),
            //Doesn't update right now
            //TODO: Ensure that AccountHeader updates after editing values
            if (editValues != null && editValues[0].value == true)
              {
                await updateUser(editValues),
              }
          }
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
        else if (item == 3)
          {
            await canLaunch(helpUrl)
                ? launch(helpUrl)
                : throw 'Could not launch $helpUrl',
          }
        else if (item == 4)
          {
            await logout(hostuid),
          }
      },
    );
  }

  AppBar accountAppBar() {
    Color backgroundColor = Theme.of(context).backgroundColor;
    if (isUserAccount) {
      return AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: settingsButton(),
          ),
        ],
      );
    }
    return AppBar(
      automaticallyImplyLeading: true,
      elevation: 0,
      backgroundColor: backgroundColor,
    );
  }

  Future<List<Poll>> getPollsFromPollIDs(List<String> pollIDs) async {
    PollRequests requests = PollRequests();
    return await requests.getPollsFromPollIDs(pollIDs, true);
  }

  Future<List<Poll>> getUserPollsByID(String uid, int type) async {
    UserController controller = UserController();
    return await controller.getUserPoll(uid, type);
  }

  Future<List<Poll>> updatePolls(String userID, int type) async {
    setState(() {
      userPollData = userPollFuture(userID);
    });
    List<KeyValue> userPollInformationTemp = await userPollData;
    setState(() {
      userPollInfo = userPollInformationTemp;
    });

    return savedPolls = userPollInformationTemp[userPollInfo
            .indexWhere((element) => element.key == type.toString())]
        .value;
  }

  Future userPollFuture(String userID) async {
    List<KeyValue> userPollTemp = new List<KeyValue>.empty(growable: true);
    userPollTemp.add(new KeyValue("1", await getUserPollsByID(userID, 1)));
    userPollTemp.add(new KeyValue("2", await getUserPollsByID(userID, 2)));
    userPollTemp.add(new KeyValue("3", await getUserPollsByID(userID, 3)));
    return userPollTemp;
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: accountAppBar(),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AccountHeader(user),
            Container(
              height: 50,
              child: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
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
              child: FutureBuilder(
                  future: userPollData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      userPollInfo = snapshot.data;
                      savedPolls = userPollInfo[userPollInfo
                              .indexWhere((element) => element.key == "1")]
                          .value;
                      recentlyRespondedToPolls = userPollInfo[userPollInfo
                              .indexWhere((element) => element.key == "2")]
                          .value;
                      myPolls = userPollInfo[userPollInfo
                              .indexWhere((element) => element.key == "3")]
                          .value;
                      return TabBarView(
                        children: <Widget>[
                          UserPollTab(
                              savedPolls, user.userID, hostuid, 1, updatePolls),
                          UserPollTab(recentlyRespondedToPolls, user.userID,
                              hostuid, 2, updatePolls),
                          UserPollTab(
                              myPolls, user.userID, hostuid, 3, updatePolls),
                        ],
                      );
                    }
                    return circularProgress();
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future logout(String userID) async {
    UserController userController = new UserController();
    await userController.logout(userID);

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("UID", "");
    preferences.setString("SessionID", "");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignInPage()));
  }
}
