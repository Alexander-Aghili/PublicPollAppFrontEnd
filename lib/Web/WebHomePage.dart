import 'package:flutter/material.dart';
import 'package:public_poll/Web/Components/SideMenu.dart';
import 'package:public_poll/Web/Screens/CreatePollPage.dart';
import 'package:public_poll/Web/Screens/ViewPollPage.dart';
import 'package:provider/provider.dart';
import 'package:public_poll/Web/WebMenuController.dart';
import '../Responsive.dart';

class WebHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WebHomePage();
}

class _WebHomePage extends State<WebHomePage> {
  PageController pageController;
  int pageIndex = 0;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuController>().scaffoldkey,
      backgroundColor: Theme.of(context).backgroundColor,
      //Main Safe Area around the web program
      drawer: SideMenu(pageController),
      body: SafeArea(
        //Row that sets up the different parts of the application
        child: Row(
          children: <Widget>[
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu(pageController),
              ),
            Expanded(
              //Takes 5/6 of screen
              flex: 5,
              child: PageView(
                children: <Widget>[
                  ViewPollPage(),
                  CreatePollPage(),
                ],
                controller: pageController,
                onPageChanged: pageChanged,
                physics: NeverScrollableScrollPhysics(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
