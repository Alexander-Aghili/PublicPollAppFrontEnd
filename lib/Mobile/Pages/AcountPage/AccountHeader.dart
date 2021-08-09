import 'package:flutter/material.dart';
import 'package:public_poll/Mobile/Widgets/Essential/Avatar.dart';
import 'package:public_poll/Models/User.dart';
import 'package:public_poll/Style.dart';

class AccountHeader extends StatefulWidget {
  final User user;
  AccountHeader(this.user);

  @override
  State<StatefulWidget> createState() => _AccountHeader(user);
}

class _AccountHeader extends State<AccountHeader> {
  User user;
  Size size;
  Image userImage;
  _AccountHeader(this.user);

  @override
  void initState() {
    super.initState();
    userImage = getAvatarForAccount();
  }

  //Get images when you set up bucket storage
  Widget userAvatar() {
    double radius = getAvatarSize(context);
    return Container(
        margin: EdgeInsets.symmetric(horizontal: size.width * .075),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            getAvatar(userImage, radius, false),
            Padding(padding: EdgeInsets.only(top: size.height * .005)),
            Text(user.firstname + " " + user.lastname),
          ],
        ));
  }

  Image getAvatarForAccount() {
    Image avatar;
    if (user.profilePictureLink == null || user.profilePictureLink == "") {
      avatar = Image.asset("assets/images/default_user_image.jpg");
    } else {
      if (user.profilePicture == null) {
        print("Making Request");
        avatar = Image.network(user.profilePictureLink);
        user.profilePicture = avatar;
      } else {
        avatar = user.profilePicture;
      }
    }
    return avatar;
  }

  //Maybe look at this?
  //https://flutteragency.com/make-text-as-big-as-the-width-allows-in-flutter/
  Widget username() {
    return Expanded(
        child: Text(
      user.username,
      style: Styles.baseTextStyle(context, getFontSizeHorziontal(context, 35)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      //decoration: BoxDecoration(border: Border.all(color: Colors.white)),
      margin: EdgeInsets.symmetric(
        horizontal: size.width * .05,
      ),
      height: size.height * .175,
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
