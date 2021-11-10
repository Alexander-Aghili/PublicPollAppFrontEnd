import 'package:flutter/material.dart';
import 'package:public_poll/Mobile/Widgets/PollListView.dart';
import 'package:public_poll/Models/Poll.dart';
import 'package:public_poll/Style.dart';

class UserPollTab extends StatefulWidget {
  final List<Poll> polls;
  final String uid;
  final int type;
  final Function updatePolls;
  final String hostuid;
  UserPollTab(this.polls, this.uid, this.hostuid, this.type, this.updatePolls);

  @override
  State<StatefulWidget> createState() => _UserPollTab(
        polls,
        uid,
        hostuid,
        type,
        updatePolls,
      );
}

class _UserPollTab extends State<UserPollTab> {
  Size size;
  String uid;
  String hostuid;
  int type;
  Widget listview;
  List<Poll> polls;
  Function updatePolls;
  _UserPollTab(this.polls, this.uid, this.hostuid, this.type, this.updatePolls);

  @override
  void initState() {
    super.initState();
    hidePrivateIfNotMainUser(polls);
  }

  void hidePrivateIfNotMainUser(List<Poll> polls) {
    try {
      int i = 0;
      while (polls[i] != null) {
        if (polls[i].isPrivate) {
          polls.removeAt(i);
        }
        i++;
      }
    } catch (e) {
      return;
    }
  }

  Future refresh() async {
    setState(() {});
    List<Poll> tempPolls = await updatePolls(uid, type);
    hidePrivateIfNotMainUser(tempPolls);
    setState(() {
      polls = tempPolls;
      listview = pollListView(
        polls,
        refresh,
        size,
        hostuid,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    if (polls.isEmpty) {
      return Center(
        child: Text("No Polls Here", style: Styles.baseTextStyle(context, 20)),
      );
    }

    listview = pollListView(
      polls,
      refresh,
      size,
      hostuid,
    );
    return listview;
  }
}
