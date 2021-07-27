import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  String uid;

  HomePage(this.uid);

  @override
  State<StatefulWidget> createState() => _HomePage(uid: uid);
}

class _HomePage extends State<HomePage> {
  PageController pageController;
  int pageIndex = 0;
  String uid;

  _HomePage({this.uid});

  void initState() {
    super.initState();
    pageController = PageController();
  }

  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void pageChanged(int pageNumber) {
    setState(() {
      this.pageIndex = pageNumber;
    });
    if (pageIndex == 0) {}
  }

  void onTapChangePage(int pageNumber) {
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
    return Scaffold(
      body: PageView(
        children: <Widget>[
          PollPage(uid),
          CreatePollPage(uid),
          AccountPage(uid),
        ],
        controller: pageController,
        onPageChanged: pageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onTapChangePage,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined, size: 35)),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined))
        ],
      ),
    );
  }
}
