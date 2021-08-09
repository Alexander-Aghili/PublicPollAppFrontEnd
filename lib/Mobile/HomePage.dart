import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:public_poll/Controller/PollRequests.dart';
import 'package:public_poll/Controller/UserController.dart';
import 'package:public_poll/Mobile/Widgets/Essential/SplashScreen.dart';
import 'package:public_poll/Models/Poll.dart';
import 'package:public_poll/Models/User.dart';

import 'Pages/AcountPage/AccountPage.dart';
import 'Pages/CreatePollPages/CreatePollPage.dart';
import 'Pages/HomePages/PollPage.dart';

/*
 * Copyright © 2021 Alexander Aghili - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Alexander Aghili alexander.w.aghili@gmail.com, May 2021
 */

class HomePage extends StatefulWidget {
  final String uid;

  HomePage(this.uid);

  @override
  State<StatefulWidget> createState() => _HomePage(uid: uid);
}

class _HomePage extends State<HomePage> {
  PageController pageController;
  int pageIndex = 0;
  String uid;
  bool freeze;

  Future accountData;
  Future homePageData;

  _HomePage({this.uid});

  Future<User> getUserFromID() async {
    UserController userController = UserController();
    return await userController.getUserByID(uid);
  }

  Future<List<Poll>> getPollsRandom() async {
    PollRequests request = PollRequests();
    return await request.getPolls(uid);
  }

  Future updatePolls() async {
    homePageData = getPollsRandom();
    return await homePageData;
  }

  Future updateUser() async {
    accountData = getUserFromID();
    return await accountData;
  }

  void initState() {
    super.initState();
    pageController = PageController();
    accountData = getUserFromID();
    homePageData = getPollsRandom();
    freeze = false;
  }

  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void freezePage() {
    setState(() {
      freeze = true;
    });
  }

  void unFreezePage() {
    setState(() {
      freeze = false;
    });
  }

  void pageChanged(int pageNumber) {
    if (freeze) return;
    setState(() {
      this.pageIndex = pageNumber;
    });
  }

  void onTapChangePage(int pageNumber) {
    if (freeze) return;
    pageController.jumpToPage(pageNumber);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Theme.of(context)
            .cupertinoOverrideTheme
            .primaryContrastingColor, // Color for Android
        statusBarBrightness:
            Theme.of(context).brightness // Dark == white status bar -- for IOS.
        ));
    return FutureBuilder(
        future: accountData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User user = snapshot.data;
            return FutureBuilder(
                future: homePageData,
                builder: (context, snapshot) {
                  if (snapshot.hasData || snapshot.hasError) {
                    return Scaffold(
                      body: AbsorbPointer(
                        absorbing: freeze,
                        child: PageView(
                          children: <Widget>[
                            if (snapshot.hasError)
                              PollPage(
                                  user,
                                  new List<Poll>.empty(growable: true),
                                  updatePolls),
                            if (!snapshot.hasError)
                              PollPage(user, snapshot.data, updatePolls),
                            CreatePollPage(uid, freezePage, unFreezePage),
                            AccountPage(user, uid, updateUser),
                          ],
                          controller: pageController,
                          onPageChanged: pageChanged,
                          physics: NeverScrollableScrollPhysics(),
                        ),
                      ),
                      bottomNavigationBar: CupertinoTabBar(
                        currentIndex: pageIndex,
                        onTap: onTapChangePage,
                        items: const <BottomNavigationBarItem>[
                          BottomNavigationBarItem(icon: Icon(Icons.home)),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.add_box_outlined, size: 35)),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.account_circle_outlined))
                        ],
                      ),
                    );
                  }
                  return splashScreen(context);
                });
          }
          return splashScreen(context);
        });
  }
}
