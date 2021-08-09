import 'package:flutter/material.dart';
import 'package:public_poll/Mobile/Widgets/PollDisplay.dart';
import 'package:public_poll/Models/Poll.dart';

Widget pollListView(
    List<Poll> polls, Function refreshList, Size size, String uid/* Must be UID of host*/) { 
  return RefreshIndicator(
    onRefresh: refreshList,
    child: ListView(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      children: createPollsUIFromListOfPolls(polls, size, uid),
    ),
  );
}

List<Widget> createPollsUIFromListOfPolls(
    List<Poll> polls, Size size, String uid) {
  List<Widget> displays = List<Widget>.empty(growable: true);
  for (int i = 0; i < polls.length; i++) {
    displays.add(createPollUIFromSinglePoll(polls[i], size, uid));
  }
  return displays;
}

Widget createPollUIFromSinglePoll(Poll poll, Size size, String uid) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: size.height * .01),
    child: PollDisplay(poll, uid, key: UniqueKey()),
  );
}
