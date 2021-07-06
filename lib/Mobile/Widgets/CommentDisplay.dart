import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:public_poll/Controller/PollRequests.dart';
import 'package:public_poll/Models/PollComment.dart';
import 'package:public_poll/Models/User.dart';

import 'Essential/MenuItem.dart';


//Removing a comment doesn't change its state and it remains
class CommentDisplay extends StatefulWidget {
  final User user;
  final PollComment comment;
  final bool isPostingUser;

  CommentDisplay(this.user, this.comment, this.isPostingUser);

  @override
  State<StatefulWidget> createState() =>
      _CommentDisplay(user, comment, isPostingUser);
}

class _CommentDisplay extends State<CommentDisplay> {
  User user;
  PollComment comment;
  bool isPostingUser;

  _CommentDisplay(this.user, this.comment, this.isPostingUser);

  Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return  Flexible(
      fit: FlexFit.loose,
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            avatarArea(),
            Expanded(
              flex: 7,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      usernameHeader(),
                      Spacer(),
                      popMenuButton(),
                    ],
                  ),
                  commentArea(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget avatarArea() {
    return Flexible(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 7.5,
          vertical: 10,
        ),
        child: CircleAvatar(
          radius: 20,
          backgroundImage:
              Image.asset("assets/images/default_user_image.jpg").image,
        ),
      ),
    );
  }

  //Padding between username and comment is here
  Widget usernameHeader() {
    return Padding(
      padding: EdgeInsets.only(bottom: 7.5, top: 10),
      child: Text(
        user.username,
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }

  Widget popMenuButton() {
    return PopupMenuButton(
      color: Theme.of(context).focusColor,
      itemBuilder: (context) => <PopupMenuEntry>[
        menuItem(
            0,
            "Report",
            Icon(
              Icons.report,
              color: Colors.red,
            ),
            color: Colors.red,
            size: size,
            context: context),
        if (isPostingUser) PopupMenuDivider(),
        if (isPostingUser)
          menuItem(
              1,
              "Delete",
              Icon(
                Icons.delete,
                color: Colors.red,
              ),
              color: Colors.red,
              size: size,
              context: context),
      ],
      onSelected: (item) async {
        PollRequests pollRequests = PollRequests();
        if (item == 1) {
          if (await pollRequests.deleteComment(comment.commentID.toString()) ==
              "ok") {

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Theme.of(context).focusColor,
                content: Text(
                  "Comment Removed", 
                  style: TextStyle(color: Theme.of(context).cupertinoOverrideTheme.primaryContrastingColor),
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Theme.of(context).focusColor,
                content: Text(
                  "Error. Comment wasn't removed. Try again.",
                  style: TextStyle(color: Theme.of(context).cupertinoOverrideTheme.primaryContrastingColor),
                ),
              ),
            );
          }
        }
      },
    );
  }

  Widget commentArea() {
    return Text(
      comment.comment,
      style: TextStyle(
        fontSize: 16,
      ),
    );
  }
}
