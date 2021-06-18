import 'package:flutter/material.dart';
import 'package:public_poll/Mobile/Widgets/Essential/Error.dart';
import 'package:public_poll/Mobile/Widgets/Essential/LoadingAction.dart';
import 'package:public_poll/Mobile/Widgets/PollDisplay.dart';
import 'package:public_poll/Models/Poll.dart';
import 'package:public_poll/Models/PollAnswer.dart';
import 'package:public_poll/Controller/PollRequests.dart';

/*
 * Copyright © 2021 Alexander Aghili - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Alexander Aghili alexander.w.aghili@gmail.com, May 2021
 */

class PollPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PollPage();
}

/*
Logic above build, widgets below.
*/
class _PollPage extends State<PollPage> {
  Size size;
  Widget listView;

  //Gets random polls using PollRequests class, gets a list of polls
  Future<List<Poll>> getPollsRandom() async {
    PollRequests request = PollRequests();
    return await request.getPolls();
  }

  //When list is refreshed
  Future<void> _refreshList() async {
    List<Poll> polls = await getPollsRandom();
    setState(() {
      listView = pollListView(polls);
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        top: true,
        child: FutureBuilder<List<Poll>>(
            future: getPollsRandom(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                listView = pollListView(snapshot.data);
                return listView;
              } else if (snapshot.hasError) {
                return errorDisplay();
              }
              return circularProgress();
            }),
      ),
    );
  }

  //The poll list
  Widget pollListView(List<Poll> polls) {
    return RefreshIndicator(
      onRefresh: _refreshList,
      child: ListView(
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        children: createPollsUIFromListOfPolls(polls),
      ),
    );
  }

  List<Widget> createPollsUIFromListOfPolls(List<Poll> polls) {
    List<Widget> displays = List<Widget>.empty(growable: true);
    for (int i = 0; i < polls.length; i++) {
      displays.add(createPollUIFromSinglePoll(polls[i]));
    }
    return displays;
  }

  Widget createPollUIFromSinglePoll(Poll poll) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: size.height * .01),
      child: PollDisplay(poll),
    );
  }
}
