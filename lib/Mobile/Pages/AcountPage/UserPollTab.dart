import 'package:flutter/material.dart';
import 'package:public_poll/Controller/PollRequests.dart';
import 'package:public_poll/Mobile/Widgets/Essential/Error.dart';
import 'package:public_poll/Mobile/Widgets/Essential/LoadingAction.dart';
import 'package:public_poll/Mobile/Widgets/PollListView.dart';
import 'package:public_poll/Models/Poll.dart';
import 'package:public_poll/Style.dart';

class UserPollTab extends StatefulWidget {
  final List<String> pollIDs;
  final String uid;
  UserPollTab(this.pollIDs, this.uid);

  @override
  State<StatefulWidget> createState() => _UserPollTab(pollIDs, uid);
}

class _UserPollTab extends State<UserPollTab> {
  Size size;
  List<String> pollIDs;
  String uid;
  _UserPollTab(this.pollIDs, this.uid);

  Future<List<Poll>> getPollsFromPollIDs() async {
    PollRequests requests = PollRequests();
    List<Poll> polls = await requests.getPollsFromPollIDs(pollIDs, true);
    return polls;
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: getPollsFromPollIDs(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Poll> polls = snapshot.data;
            if (polls.isEmpty) {
              return Center(
                child: Text("No Polls Here",
                    style: Styles.baseTextStyle(context, 20)),
              );
            }
            //Else
            return pollListView(polls, getPollsFromPollIDs, size, uid);
          } else if (snapshot.hasError) {
            return errorDisplay();
          }
          return circularProgress();
        });
  }
}
