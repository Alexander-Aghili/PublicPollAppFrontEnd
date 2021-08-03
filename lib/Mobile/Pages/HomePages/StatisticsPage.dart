import 'package:flutter/material.dart';
import 'package:public_poll/Mobile/Widgets/Essential/Header.dart';
import 'package:public_poll/Models/Poll.dart';
import 'package:public_poll/Models/PollAnswer.dart';

/*
 * Copyright © 2021 Alexander Aghili - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Alexander Aghili alexander.w.aghili@gmail.com, May 2021
 */

class StatisticsPage extends StatelessWidget {
  Poll poll;

  StatisticsPage({@required this.poll});

  Size size;
  int total;
  Color conColor;

  int getTotal() {
    int total = 0;
    for (int i = 0; i < poll.answers.length; i++) {
      total += poll.answers[i].userIDs.length;
    }
    return total;
  }

  Column barGraph() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: getBarComponents(),
    );
  }

  List<Widget> getBarComponents() {
    List<Widget> components = new List<Widget>.empty(growable: true);
    for (int i = 0; i < poll.answers.length; i++) {
      PollAnswer pollAnswer = poll.answers[i];
      double percentage = (poll.answers[i].userIDs.length) / total;
      if (percentage.isNaN || percentage.isInfinite) percentage = 0;

      components.add(barComponent(
          pollAnswer.letter, pollAnswer.userIDs.length, percentage));
    }
    return components;
  }

  Widget barComponent(String letter, int amount, double percentage) {
    return Container(
      margin: EdgeInsets.only(bottom: size.height * .01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(letter + ") "),
          ),
          Container(
            width: size.width * .65 * percentage,
            decoration: BoxDecoration(border: Border.all(color: conColor)),
            height: 25,
            child: Container(
              color: Colors.red,
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(amount.toString()),
          ),
        ],
      ),
    );
  }

  Widget totalVotes() {
    return Container(
      child: Center(
        child: Text("Total Votes: " + total.toString(), style: TextStyle(fontSize: 20))),
    );
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    conColor = Theme.of(context).cupertinoOverrideTheme.primaryContrastingColor;
    total = getTotal();

    return Scaffold(
      appBar: header(
          context: context,
          isAppTitle: false,
          title: "Statistics",
          eliminateBackButton: false),
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            totalVotes(),
            barGraph(),
          ],
        ),
      ),
    );
  }
}
