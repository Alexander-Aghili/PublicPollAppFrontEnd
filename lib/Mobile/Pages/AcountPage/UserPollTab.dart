import 'package:flutter/material.dart';
import 'package:public_poll/Controller/PollRequests.dart';
import 'package:public_poll/Mobile/Widgets/Essential/Error.dart';
import 'package:public_poll/Mobile/Widgets/Essential/LoadingAction.dart';
import 'package:public_poll/Mobile/Widgets/PollListView.dart';
import 'package:public_poll/Models/Poll.dart';
import 'package:public_poll/Models/User.dart';
import 'package:public_poll/Style.dart';

class UserPollTab extends StatefulWidget {
  List<String> pollIDs;
  UserPollTab(this.pollIDs);

  @override
  State<StatefulWidget> createState() => _UserPollTab(pollIDs);
}

class _UserPollTab extends State<UserPollTab> {
  Size size;
  List<String> pollIDs;
  _UserPollTab(this.pollIDs);

  Future<List<Poll>> getPollsFromPollIDs() async {
    PollRequests requests = PollRequests();
    List<Poll> polls = await requests.getPollsFromPollIDs(pollIDs);
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
                child: Text("No Polls Here", style: Styles.baseTextStyle(context, 20)),
              );
            }
            //Else
            return pollListView(polls, getPollsFromPollIDs, size);
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return errorDisplay();
          }
          return circularProgress();
        });
  }
}
