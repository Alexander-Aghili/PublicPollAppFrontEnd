import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:public_poll/Mobile/Pages/HomePages/CommentPage.dart';
import 'package:public_poll/Mobile/Pages/HomePages/StatisticsPage.dart';
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

/*
PAIN
TO DO:
-Fix Clicking to show all states for one click
-Add selecting your answer
-Add comments
-Fix length of issue and container size issue
-Add statistics
-Implement 3 dot menu items
-touch up
*/

class PollDisplay extends StatelessWidget {
  Poll poll;
  Color contrastColor;
  Size size;
  BuildContext context;
  int totalVotes;
  Widget rowState;

  PollDisplay(this.poll);

  //Calculate for different screen widths, specifically the /42 number
  int calculateLinesForQuestion() {
    return (poll.pollQuestion.length / 42).floor().round();
  }

  int getTotalVotes() {
    int votes = 0;
    for (int i = 0; i < poll.answers.length; i++) {
      votes += poll.answers[i].numClicked;
    }
    return votes;
  }

  /*
  Init state of poll, doesn't display data of poll, 
  that is a differnt dart class
  */
  @override
  Widget build(BuildContext context) {
    totalVotes = getTotalVotes();
    size = MediaQuery.of(context).size;
    this.context = context;
    contrastColor =
        Theme.of(context).cupertinoOverrideTheme.primaryContrastingColor;
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          border: Border.all(color: contrastColor, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      width: size.width,
      height: size.height *
          (.275 +
              (.05 * poll.answers.length) +
              (.025 * calculateLinesForQuestion())),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          questionRow(context),
          answersColumn(context),
          Spacer(),
          bottomDataRow(),
        ],
      ),
    );
  }

  Row questionRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Spacer(),
        //For some fucking reason it isn't center and I wanna fucking kill this thing
        Expanded(
          flex: 20,
          child: Container(
            alignment: Alignment.center,
            padding:
                EdgeInsets.only(left: size.width * .1, top: size.height * .025),
            child: Text(
              poll.pollQuestion,
              style: Styles.baseTextStyle(context, 25),
            ),
          ),
        ),
        Spacer(),
        PopupMenuButton(
          color: Theme.of(context).primaryColor,
          itemBuilder: (context) => <PopupMenuEntry>[
            menuItem(
              0,
              "Save",
              Icon(Icons.archive),
              size: size,
              context: context,
            ),
            PopupMenuDivider(),
            menuItem(
                1,
                "Report",
                Icon(
                  Icons.report,
                  color: Colors.red,
                ),
                color: Colors.red,
                size: size,
                context: context
              ),
          ],
          onSelected: (item) => {},
        ),
      ],
    );
  }

  Widget answersColumn(BuildContext context) {
    return PollAnswerDisplaySystem(
      poll: poll,
      size: size,
      color: contrastColor,
      totalVotes: totalVotes,
    );
  }

  Row bottomDataRow() {
    Icon shareIcon;
    if (Platform.isAndroid)
      shareIcon = Icon(Icons.share);
    else
      shareIcon = Icon(Icons.ios_share);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CommentPage(comments: poll.comments))),
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
            "http://localhost:8081/PublicPollBackEnd/pollDisplay/" +
                poll.pollID.toString(),
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

class PollAnswerDisplaySystem extends StatefulWidget {
  Poll poll;
  Size size;
  Color color;
  int totalVotes;

  PollAnswerDisplaySystem({this.poll, this.size, this.color, this.totalVotes});

  @override
  State<StatefulWidget> createState() => _PollAnswerDisplaySystem(
        poll: poll,
        size: size,
        color: color,
        totalVotes: totalVotes,
      );
}

class _PollAnswerDisplaySystem extends State<PollAnswerDisplaySystem> {
  Poll poll;
  Size size;
  Color color;
  int totalVotes;
  Function fuction;

  _PollAnswerDisplaySystem({this.poll, this.size, this.color, this.totalVotes});

  @override
  void initState() {
    super.initState();
    fuction = pollAnswerBase;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: size.height * .015),
        ),
        for (int i = 0; i < poll.answers.length; i++) fuction(i),
      ],
    );
  }

  Widget pollAnswerBase(int pollAnswerNumber) {
    PollAnswer answer = poll.answers[pollAnswerNumber];
    PollAnswerDisplay display = getDisplay(answer, false);
    return GestureDetector(
      onTap: () => null,
      child: display,
    );
  }

  Widget pollAnswerDisplayPercentage(int pollAnswerNumber) {
    PollAnswer answer = poll.answers[pollAnswerNumber];
    PollAnswerDisplay display = getDisplay(answer, true);
    return GestureDetector(
      onTap: () => null,
      child: display,
    );
  }

  PollAnswerDisplay getDisplay(PollAnswer answer, bool showAnswers) {
    return PollAnswerDisplay(
      pollAnswer: answer,
      size: size,
      color: color,
      context: context,
      totalVotes: totalVotes,
      showAnswers: showAnswers,
    );
  }
}

class PollAnswerDisplay extends StatefulWidget {
  PollAnswer pollAnswer;
  int totalVotes;
  Size size;
  Color color;
  BuildContext context;
  bool showAnswers;

  PollAnswerDisplay({
    @required this.pollAnswer,
    @required this.size,
    @required this.color,
    @required this.context,
    @required this.totalVotes,
    @required this.showAnswers,
  });
  @override
  State<StatefulWidget> createState() => _PollAnswerDisplay(
        pollAnswer: pollAnswer,
        size: size,
        color: color,
        context: context,
        totalVotes: totalVotes,
        showAnswers: showAnswers,
      );
}

class _PollAnswerDisplay extends State<PollAnswerDisplay> {
  PollAnswer pollAnswer;
  int totalVotes;
  Size size;
  Color color;
  BuildContext context;
  bool isSelected;
  bool showAnswers;

  _PollAnswerDisplay({
    @required this.pollAnswer,
    @required this.size,
    @required this.color,
    @required this.context,
    @required this.totalVotes,
    @required this.showAnswers,
  });

  Container baseState() {
    return Container(
      margin: EdgeInsets.only(
        top: size.height * .015,
        bottom: size.height * .015,
        left: size.width * .05,
        right: size.width * .05,
      ),
      height: size.height * .055,
      decoration: BoxDecoration(
          border: Border.all(
            color: color,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: _answerRow(),
    );
  }

  Container answeredDisplay() {
    return Container(
      margin: EdgeInsets.only(
        top: size.height * .015,
        bottom: size.height * .015,
        left: size.width * .05,
        right: size.width * .05,
      ),
      height: size.height * .055,
      child: Row(
        children: <Widget>[
          _containerAnsweredState(),
          Spacer(),
          _percentageInformation(),
        ],
      ),
    );
  }

  Container _containerAnsweredState() {
    return Container(
      width: size.width * .75,
      height: size.height * .055,
      decoration: BoxDecoration(
          border: Border.all(
            color: color,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: _answerRow(),
    );
  }

  Row _answerRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: size.width * .025),
          child: Text(
            pollAnswer.letter + ") ",
            style: Styles.baseTextStyle(context, 22),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: size.width * .05),
          child: Text(
            pollAnswer.answer,
            style: Styles.baseTextStyle(context, 24),
          ),
        ),
      ],
    );
  }

  Container _percentageInformation() {
    int percentage = ((pollAnswer.numClicked / totalVotes) * 100).toInt();
    return Container(
      child: Text(
        percentage.toString() + "%",
        style: Styles.baseTextStyle(context, 25),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!showAnswers)
      return baseState();
    else
      return answeredDisplay();
  }
}
