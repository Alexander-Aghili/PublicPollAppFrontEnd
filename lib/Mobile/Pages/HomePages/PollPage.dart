import 'package:flutter/material.dart';
import 'package:public_poll/Mobile/Widgets/Essential/LoadingAction.dart';
import 'package:public_poll/Mobile/Widgets/PollListView.dart';
import 'package:public_poll/Models/Poll.dart';
import 'package:public_poll/Controller/PollRequests.dart';
import 'package:public_poll/Models/User.dart';

/*
 * Copyright © 2021 Alexander Aghili - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Alexander Aghili alexander.w.aghili@gmail.com, May 2021
 */

class PollPage extends StatefulWidget {
  final User user;
  final List<Poll> polls;
  final Function updatePollsFunction;
  PollPage(this.user, this.polls, this.updatePollsFunction);

  @override
  State<StatefulWidget> createState() =>
      _PollPage(user, polls, updatePollsFunction);
}

/*
Logic above build, widgets below.
*/
class _PollPage extends State<PollPage> {
  Size size;
  Widget listView;

  User user;
  List<Poll> polls;
  Function updatePollsFunction;
  _PollPage(this.user, this.polls, this.updatePollsFunction);

  //Gets random polls using PollRequests class, gets a list of polls
  Future<List<Poll>> getPollsRandom() async {
    PollRequests request = PollRequests();
    return await request.getPolls(user.userID);
  }

  //When list is refreshed
  Future<void> _refreshList() async {
    List<Poll> tempPolls = await updatePollsFunction();
    setState(() {
      polls = tempPolls;
      listView = pollListView(polls, _refreshList, size, user.userID);
    });
  }

  /*
  Add reload button under errorDisplay
  */
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    if (polls.isEmpty) {
      listView = Center(
        child: Container(
          child: Text(
            "No new polls.\nCheck back later!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25),
          ),
        ),
      );
    } else {
      listView = pollListView(polls, _refreshList, size, user.userID);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        top: true,
        child: listView,
      ),
    );
  }
}
