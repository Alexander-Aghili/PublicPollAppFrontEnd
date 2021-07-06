import 'package:flutter/material.dart';
import 'package:public_poll/Models/User.dart';
import 'package:public_poll/Style.dart';

class AccountHeader extends StatefulWidget {
  User user;
  AccountHeader(this.user);

  @override
  State<StatefulWidget> createState() => _AccountHeader(user);
}

class _AccountHeader extends State<AccountHeader> {
  User user;
  Size size;
  _AccountHeader(this.user);

  //Get images when you set up bucket storage
  Widget userAvatar() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: size.width * .075),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 45,
              backgroundImage:
                  Image.asset("assets/images/default_user_image.jpg").image,
            ),
            Padding(padding: EdgeInsets.only(top: size.height * .005)),
            Text(user.firstname + " " + user.lastname),
          ],
        ));
  }


  //Maybe look at this?
  //https://flutteragency.com/make-text-as-big-as-the-width-allows-in-flutter/
  Widget username() {
    return Expanded(
       child: Text(user.username, style: Styles.baseTextStyle(context, 40),)
    );
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      //decoration: BoxDecoration(border: Border.all(color: Colors.white)),
      margin: EdgeInsets.symmetric(
        horizontal: size.width * .05,
      ),
      height: size.height * .15,
      width: size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          userAvatar(),
          username(),
        ],
      ),
    );
  }
}
