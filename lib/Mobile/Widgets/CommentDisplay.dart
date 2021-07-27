import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:public_poll/Controller/PollRequests.dart';
import 'package:public_poll/Mobile/Widgets/Alert.dart';
import 'package:public_poll/Models/PollComment.dart';
import 'package:public_poll/Models/User.dart';

import 'Essential/MenuItem.dart';

//Removing a comment doesn't change its state and it remains
class CommentDisplay extends StatefulWidget {
  final User user;
  final PollComment comment;
  final bool isPostingUser;
  final Function deleteComment;
  final Key key;

  CommentDisplay(
      this.user, this.comment, this.isPostingUser, this.deleteComment,
      {this.key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _CommentDisplay(user, comment, isPostingUser, deleteComment);
}

class _CommentDisplay extends State<CommentDisplay> {
  User user;
  PollComment comment;
  bool isPostingUser;
  Function deleteComment;

  _CommentDisplay(
      this.user, this.comment, this.isPostingUser, this.deleteComment);

  Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Flexible(
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
        padding: EdgeInsets.only(
          left: 7.5,
          right: 7.5,
          top: 20,
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
      padding: EdgeInsets.only(bottom: 0, top: 15),
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
      padding: EdgeInsets.symmetric(vertical: 5),
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
        if (item == 0) {
          showDialog(
            context: context,
            builder: (context) {
              return report(context, comment.commentID.toString(), "comment");
            },
          );
        }

        if (item == 1) {
          String response =
              await pollRequests.deleteComment(comment.commentID.toString());
          if (response == "ok") {
            deleteComment(comment);
            removedSnackBar("Comment Removed", context);
          } else {
            errorSnackBar("Error. Comment wasn't removed. Try again.", context);
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
