import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:public_poll/Controller/PollRequests.dart';
import 'package:public_poll/Controller/UserController.dart';
import 'package:public_poll/Mobile/Widgets/CommentDisplay.dart';
import 'package:public_poll/Mobile/Widgets/Essential/Header.dart';
import 'package:public_poll/Mobile/Widgets/Essential/LoadingAction.dart';
import 'package:public_poll/Models/PollComment.dart';
import 'package:public_poll/Models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
 * Copyright © 2021 Alexander Aghili - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Alexander Aghili alexander.w.aghili@gmail.com, May 2021
 */

class CommentPage extends StatefulWidget {
  final List<PollComment> comments;
  final String pollID;
  final String hostuid;
  CommentPage({
    @required this.comments,
    @required this.pollID,
    @required this.hostuid,
  });

  @override
  State<StatefulWidget> createState() =>
      _CommentPage(comments: comments, pollID: pollID, hostuid: hostuid);
}

class _CommentPage extends State<CommentPage> {
  List<PollComment> comments;
  String pollID;
  String hostuid;

  _CommentPage({@required this.comments, @required this.pollID, @required this.hostuid});

  Color constrastColor;
  TextEditingController commentController = TextEditingController();
  OutlineInputBorder commentBorder;
  Size size;

  Future futureData;

  List<Widget> commentDisplays;
  List<User> users;

  String uid;

  @override
  void initState() {
    super.initState();
    futureData = getUsers();
  }

  Future<List<User>> getUsers() async {
    //Get this userID
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString("UID");

    if (comments.isEmpty) {
      return new List<User>.empty(growable: true);
    }

    UserController controller = UserController();
    List<String> userIDs = List<String>.empty(growable: true);
    for (int i = 0; i < comments.length; i++) {
      userIDs.add(comments[i].user);
    }
    List<User> users = await controller.getUsersFromIDs(userIDs);
    return users;
  }

  @override
  Widget build(BuildContext context) {
    //Init
    size = MediaQuery.of(context).size;
    constrastColor =
        Theme.of(context).cupertinoOverrideTheme.primaryContrastingColor;

    commentBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide(color: constrastColor),
    );

    return Scaffold(
      appBar: header(
          context: context,
          isAppTitle: false,
          title: "Comments",
          eliminateBackButton: false),
      backgroundColor: Theme.of(context).primaryColor,
      body: FutureBuilder<List<User>>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            users = snapshot.data;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (snapshot.data.isEmpty)
                  Expanded(
                    child: Container(),
                  ),
                if (snapshot.data.isNotEmpty)
                  Expanded(
                    child: commentListView(),
                  ),
                commentBar(),
                Padding(padding: EdgeInsets.only(bottom: 25))
              ],
            );
          }
          return Padding(
            padding: EdgeInsets.only(bottom: size.height * .15),
            child: circularProgress(),
          );
        },
      ),
    );
  }

  Widget commentListView() {
    commentDisplays = getCommentDisplays(users);
    return ListView(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: commentDisplays,
        ),
      ],
    );
  }

  void deleteComment(PollComment comment) {
    setState(() {
      comments.remove(comment);
      if (comment.commentID != 0) {
        users.removeWhere((element) => element.commentID == comment.commentID);
      }
      commentDisplays = getCommentDisplays(users);
    });
  }

  List<Widget> getCommentDisplays(List<User> userList) {
    List<Widget> commentDisplays = new List<Widget>.empty(growable: true);
    for (int i = 0; i < comments.length; i++) {
      try {
        users[i].commentID = comments[i].commentID;
        bool isPostingUser = userList[i].userID == uid;
        commentDisplays.add(CommentDisplay(
          userList[i],
          comments[i],
          isPostingUser,
          deleteComment,
          hostuid,
          key: UniqueKey(),
        ));
      } catch (e) {
        //Error occurs here once during rebuild but then works
      }
    }
    return commentDisplays;
  }

  Widget commentBar() {
    return Container(
      alignment: Alignment.center,
      width: size.width * .9,
      child: TextField(
        controller: commentController,
        decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).focusColor,
            border: commentBorder,
            focusedBorder: commentBorder,
            suffixIcon: IconButton(
              iconSize: 20,
              icon: Icon(Icons.send),
              color: constrastColor,
              onPressed: () async => addComment(),
            )),
        maxLines: null,
        maxLength: 500,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        keyboardType: TextInputType.streetAddress,
        cursorColor: constrastColor,
      ),
    );
  }

  Future addComment() async {
    if (commentController.text.trim() == "") return;
    //Get UID

    PollComment comment = new PollComment(
        pollID: pollID,
        comment: commentController.text.trim(),
        user: uid,
        commentID: 0);

    PollRequests controller = PollRequests();
    String id = await controller.addComment(comment);

    if (id == "error") {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("An error has occured, try again."),
            );
          });
    } else {
      comment.commentID = int.parse(id);
      setState(() {
        comments.add(comment);
      });

      futureData = getUsers();
      users = await futureData;

      setState(() {
        commentDisplays = getCommentDisplays(users);
        commentController.clear();
      });
    }
  }
}
