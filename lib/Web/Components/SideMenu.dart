import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:public_poll/Web/Screens/ViewPollPage.dart';

class SideMenu extends StatelessWidget {
  PageController page;
  SideMenu(this.page, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color iconColor =
        Theme.of(context).cupertinoOverrideTheme.primaryContrastingColor;
    return Drawer(
      child: SingleChildScrollView(
        // it enables scrolling
        child: Column(
          children: [
            DrawerHeader(
              child: Image.asset("images/poll_image.png"),
            ),
            DrawerListTile(
              title: "Home",
              svg: Icon(Icons.home, color: iconColor,),
              press: () {
                page.jumpToPage(0);
              },
            ),
            DrawerListTile(
              title: "Create Poll",
              svg: Icon(Icons.add_box_outlined, color: iconColor,),
              press: () {
                page.jumpToPage(1);
              },
            ),
            DrawerListTile(
              title: "Account", 
              svg: Icon(Icons.account_circle_outlined, color: iconColor,), 
              press: null,
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key key,
    // For selecting those three line once press "Command+D"
    @required this.title,
    @required this.svg,
    @required this.press,
  }) : super(key: key);

  final String title;
  final Icon svg;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      minVerticalPadding: 20,
      leading: svg,
      title: Text(
        title,
        style: TextStyle(
            color: Theme.of(context)
                .cupertinoOverrideTheme
                .primaryContrastingColor),
      ),
    );
  }
}
