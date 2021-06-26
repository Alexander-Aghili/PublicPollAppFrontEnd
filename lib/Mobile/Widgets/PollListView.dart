import 'package:flutter/material.dart';
import 'package:public_poll/Mobile/Widgets/PollDisplay.dart';
import 'package:public_poll/Models/Poll.dart';

Widget pollListView(List<Poll> polls, Function refreshList, Size size) {
  return RefreshIndicator(
    onRefresh: refreshList,
    child: ListView(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      children: createPollsUIFromListOfPolls(polls, size),
    ),
  );
}

List<Widget> createPollsUIFromListOfPolls(List<Poll> polls, Size size) {
  List<Widget> displays = List<Widget>.empty(growable: true);
  for (int i = 0; i < polls.length; i++) {
    displays.add(createPollUIFromSinglePoll(polls[i], size));
  }
  return displays;
}

Widget createPollUIFromSinglePoll(Poll poll, Size size) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: size.height * .01),
    child: PollDisplay(poll),
  );
}