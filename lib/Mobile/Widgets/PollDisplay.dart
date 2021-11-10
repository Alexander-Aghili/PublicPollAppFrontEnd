import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:public_poll/Controller/Domain.dart';
import 'package:public_poll/Controller/PollRequests.dart';
import 'package:public_poll/Controller/UserController.dart';
import 'package:public_poll/Mobile/Pages/HomePages/CommentPage.dart';
import 'package:public_poll/Mobile/Pages/HomePages/StatisticsPage.dart';
import 'package:public_poll/Mobile/Widgets/Alert.dart';
import 'package:public_poll/Models/Poll.dart';
import 'package:public_poll/Models/PollAnswer.dart';
import 'package:public_poll/Style.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io' show Platform;

import 'Essential/MenuItem.dart';

/*
 * Copyright © 2021 Alexander Aghili - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Alexander Aghili alexander.w.aghili@gmail.com, May 2021
 */

class PollDisplay extends StatefulWidget {
  final Poll poll;
  final String
      userID; // You always want this person to be the person who is logged in,
  //ei. localstorage "UID" would return this
  PollDisplay(this.poll, this.userID, {@required Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PollDisplay(poll, userID);
}

class _PollDisplay extends State<PollDisplay> {
  Poll poll;

  _PollDisplay(this.poll, this.userID) {
    //Poll init
    totalVotes = 0;
    for (int i = 0; i < poll.answers.length; i++) {
      PollAnswer answer = poll.answers[i];
      totalVotes += answer.userIDs.length;

      if (answer.userIDs.contains(userID)) {
        selectedAnswer = answer.letter;
      }
    }
  }

  bool isSaved;

  Size size;
  String selectedAnswer;
  int totalVotes;
  String userID;
  Future isSavedFuture;

  @override
  void initState() {
    super.initState();
    isSavedFuture = getSavedState();
  }

  Color contrastColor;
  /*
  Init state of poll, doesn't display data of poll, 
  that is a differnt dart class
  */
  @override
  Widget build(BuildContext context) {
    contrastColor =
        Theme.of(context).cupertinoOverrideTheme.primaryContrastingColor;
    size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          border: Border.all(color: contrastColor, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          questionRow(),
          AnswerArea(poll, selectedAnswer, totalVotes, userID, poll.pollID),
          bottomDataRow(),
        ],
      ),
    );
  }

  Future getSavedState() async {
    if (isSaved != null) return isSaved;
    UserController controller = UserController();
    return await controller.checkUserPollExists(userID, poll.pollID, 1);
  }

  Row questionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (poll.isPrivate)
          Container(
            padding:
                EdgeInsets.only(left: size.width * .05, top: size.height * .02),
            child: Icon(
              Icons.lock,
              size: 23,
            ),
          ),
        if (!poll.isPrivate)
          Container(
            padding:
                EdgeInsets.only(left: size.width * .05, top: size.height * .02),
          ),
        //For some fucking reason it isn't center and I wanna fucking kill this thing
        Expanded(
          flex: 20,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Text(
              poll.pollQuestion,
              style: Styles.baseTextStyle(context, 25),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        FutureBuilder(
            future: isSavedFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                isSaved = snapshot.data;
                return PopupMenuButton(
                  color: Theme.of(context).primaryColor,
                  itemBuilder: (context) => <PopupMenuEntry>[
                    if (!isSaved)
                      menuItem(0, "Save", Icon(Icons.archive),
                          size: size, context: context, extraPadding: true),
                    if (isSaved)
                      menuItem(0, "Unsave", Icon(Icons.crop),
                          size: size, context: context, extraPadding: true),
                    PopupMenuDivider(),
                    if (userID != poll.creatorID)
                      menuItem(
                          1,
                          "Report",
                          Icon(
                            Icons.report,
                            color: Colors.red,
                          ),
                          color: Colors.red,
                          size: size,
                          context: context,
                          extraPadding: true),
                    if (userID == poll.creatorID)
                      menuItem(
                          2,
                          "Delete",
                          Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          color: Colors.red,
                          size: size,
                          context: context,
                          extraPadding: true),
                  ],
                  onSelected: (item) async {
                    if (item == 0 && !isSaved) {
                      UserController controller = UserController();
                      if (await controller.addUserPolls(
                              userID, poll.pollID, 1) ==
                          "ok") {
                        removedSnackBar("Poll Saved", context);
                      } else {
                        errorSnackBar("Cannot save poll", context);
                      }
                      setState(() {
                        isSaved = true;
                      });
                    } else if (item == 0 && isSaved) {
                      UserController controller = UserController();
                      if (await controller.deleteUserPoll(
                              userID, poll.pollID, 1) ==
                          "ok") {
                        removedSnackBar("Poll Unsaved", context);
                      } else {
                        errorSnackBar("Cannot unsave polls", context);
                      }
                      setState(() {
                        isSaved = false;
                      });
                    }

                    if (item == 1) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return report(context, poll.pollID, "poll", userID);
                          });
                    } else if (item == 2) {
                      confirmDelete(context, deleteFunction);
                    }
                  },
                );
              }
              return PopupMenuButton(
                  itemBuilder: (context) => <PopupMenuEntry>[]);
            }),
      ],
    );
  }

  Future deleteFunction() async {
    PollRequests requests = PollRequests();

    String response =
          await requests.deletePoll(userID, poll.pollID);
      if (response == "ok")
        removedSnackBar("Poll Deleted", context);
      else {
        errorSnackBar(
            "Error. Could not delete poll. Try again.",
            context);
      }
  }

  Row bottomDataRow() {
    Icon shareIcon;
    if (kIsWeb || Platform.isAndroid)
      shareIcon = Icon(Icons.share);
    else
      shareIcon = Icon(Icons.ios_share);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CommentPage(
                          comments: poll.comments,
                          pollID: poll.pollID,
                          hostuid: userID,
                        )));
          },
          child: bottomRowIcon(Icon(Icons.comment), Alignment.centerLeft),
        ),
        Spacer(),
        GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StatisticsPage(poll: poll))),
          child: bottomRowIcon(
              Icon(
                Icons.bar_chart,
                size: 26,
              ),
              Alignment.center),
        ),
        Spacer(),
        GestureDetector(
          onTap: () => Share.share(
            Domain.getWeb() + 'pollDisplay?id=' + poll.pollID.toString(),
          ),
          child: bottomRowIcon(shareIcon, Alignment.centerRight),
        ),
      ],
    );
  }

  Container bottomRowIcon(Icon icon, Alignment alignment) {
    return Container(
      //Hidden, designed to extend clickable area of icons
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).backgroundColor)),
      alignment: alignment,
      padding: EdgeInsets.symmetric(
        vertical: size.height * .01,
      ),
      margin:
          EdgeInsets.only(left: size.width * .025, right: size.width * .025),
      width: size.width * .2,
      child: icon,
    );
  }
}

class AnswerArea extends StatefulWidget {
  final Poll poll;
  final String selectedAnswer;
  final int totalVotes;
  final String uid;
  final String pid;

  AnswerArea(
      this.poll, this.selectedAnswer, this.totalVotes, this.uid, this.pid);

  @override
  State<StatefulWidget> createState() =>
      _AnswerArea(poll, selectedAnswer, totalVotes, uid, pid);
}

class _AnswerArea extends State<AnswerArea> {
  Poll poll;
  String selectedAnswer;
  int totalVotes;
  String uid;
  String pid;

  _AnswerArea(
      this.poll, this.selectedAnswer, this.totalVotes, this.uid, this.pid);

  List<Widget> answerBoxes;

  List<Widget> getAnswerBoxes() {
    List<Widget> boxes = List<Widget>.empty(growable: true);

    for (int i = 0; i < poll.answers.length; i++) {
      boxes.add(AnswerBox(
        poll.answers[i],
        key: UniqueKey(),
        notifyParent: updateWidget,
        selectedAnswer: this.selectedAnswer,
        totalVotes: this.totalVotes,
        uid: this.uid,
        pid: this.pid,
      ));
    }
    return boxes;
  }

  void updateWidget(String answer) {
    setState(() {
      selectedAnswer = answer;
      totalVotes += 1;
      answerBoxes = getAnswerBoxes();
    });
  }

  @override
  Widget build(BuildContext context) {
    answerBoxes = getAnswerBoxes();

    return ListView(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: answerBoxes,
        ),
      ],
    );
  }
}

class AnswerBox extends StatefulWidget {
  final PollAnswer answer;
  final Function notifyParent;
  final String selectedAnswer;
  final int totalVotes;
  final String uid;
  final String pid;

  AnswerBox(this.answer,
      {@required Key key,
      @required this.notifyParent,
      @required this.selectedAnswer,
      @required this.totalVotes,
      @required this.uid,
      @required this.pid})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _AnswerBox(
      this.answer,
      this.notifyParent,
      this.selectedAnswer,
      this.totalVotes,
      this.uid,
      this.pid);
}

class _AnswerBox extends State<AnswerBox> {
  PollAnswer answer;
  Function notifyParent;
  String selectedAnswer;
  int totalVotes;
  String uid;
  String pid;

  _AnswerBox(this.answer, this.notifyParent, this.selectedAnswer,
      this.totalVotes, this.uid, this.pid);

  Color borderColor;
  Color backColor;
  double borderWidth;

  void changeBorder() {
    borderColor = Colors.blue;
    backColor = Colors.blue.shade200;
    borderWidth = 5;
  }

  void answerClicked() async {
    if (selectedAnswer == null) {
      setState(() {
        if (answer.userIDs == null || answer.userIDs.isEmpty) {
          answer.userIDs = new List<String>.empty(growable: true);
        }
        answer.userIDs.add(uid);

        selectedAnswer = answer.letter;
        changeBorder();
        notifyParent(answer.letter);
      });

      PollRequests requests = PollRequests();
      String response =
          await requests.addUserResponseToPoll(uid, pid, answer.letter);

      if (response == "duplicate") {
        return;
      }

      if (response != "ok") {
        errorSnackBar("Answer not logged.", context);
        return;
      }

      UserController controller = UserController();
      response = await controller.addUserPolls(uid, pid, 2);

      if (response != "ok") {
        errorSnackBar("Error saving", context);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (selectedAnswer == answer.letter) {
      changeBorder();
    } else {
      borderColor =
          Theme.of(context).cupertinoOverrideTheme.primaryContrastingColor;
      backColor = Theme.of(context).backgroundColor;
      borderWidth = 1;
    }

    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            width: size.width * .8,
            decoration: BoxDecoration(
              color: backColor,
              border: Border.all(
                color: borderColor,
                width: borderWidth,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: GestureDetector(
              onTap: answerClicked,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 10,
                    ),
                    child: Text(
                      answer.letter + ")",
                      style: Styles.baseTextStyle(context, 20),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        answer.answer,
                        style: Styles.baseTextStyle(context, 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  if (selectedAnswer != null)
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        getVotePercentage(answer.userIDs.length),
                        style: Styles.baseTextStyle(context, 14),
                      ),
                    ),
                  if (selectedAnswer == null)
                    Container(
                      width: 35,
                      child: Text(""),
                    ), //Empty container to not press the text up again the corner of the box
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getVotePercentage(int votes) {
    String percentage;
    try {
      double dec = votes / totalVotes;
      if (dec.isNaN) throw Exception();
      percentage = (100 * (dec)).toStringAsFixed(2);
    } catch (e) {
      percentage = "0";
    }
    return percentage += "%";
  }
}
