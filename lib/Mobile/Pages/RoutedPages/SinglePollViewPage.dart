import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:public_poll/Controller/PollRequests.dart';
import 'package:public_poll/Mobile/Widgets/Essential/LoadingAction.dart';
import 'package:public_poll/Mobile/Widgets/PollDisplay.dart';
import 'package:public_poll/Models/Poll.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SinglePollViewPage extends StatefulWidget {
  final String pollID;

  SinglePollViewPage(this.pollID);

  @override
  State<StatefulWidget> createState() => _SinglePollViewPage(pollID);
}

class _SinglePollViewPage extends State<SinglePollViewPage> {
  String pollID;
  _SinglePollViewPage(this.pollID);

  String userID;
  Future pollFuture;

  Future<Poll> getPollData() async {
    String userID = await SharedPreferences.getInstance()
        .then((prefs) => prefs.getString("UID"));
    PollRequests requests = PollRequests();
    return await requests.getPollByID(pollID);
  }

  @override
  void initState() {
    super.initState();
    pollFuture = getPollData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: pollFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Poll poll = snapshot.data;
            return ListView(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              children: [
                PollDisplay(poll, userID, key: UniqueKey()),
              ],
            );
          }
          return circularProgress();
        });
  }
}
