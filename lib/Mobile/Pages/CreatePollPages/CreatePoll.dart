import 'package:flutter/material.dart';
import 'package:public_poll/Mobile/Pages/CreatePollPages/AnswerBox.dart';
import 'package:public_poll/Models/Poll.dart';
import 'package:public_poll/Models/PollAnswer.dart';

class CreatePoll {
  // ignore: deprecated_member_use
  List<AnswerBox> answerBoxes;
  String question;
  bool isPrivatePoll;
  String uid;

  CreatePoll({
      @required this.uid,
      @required this.answerBoxes,
      @required this.question,
      @required this.isPrivatePoll});

  //Not needed but used, for organizational purposes
  Poll getPoll() {
    return createPoll();
  }

  Poll createPoll() {
    List<PollAnswer> answers = getAnswersFromAnswerBox();
    return Poll( creatorID: uid,
        pollQuestion: question, answers: answers, isPrivate: isPrivatePoll);
  }

  List<PollAnswer> getAnswersFromAnswerBox() {
    // ignore: deprecated_member_use
    List<PollAnswer> answers = List<PollAnswer>();
    for (int i = 0; i < answerBoxes.length; i++) {
      AnswerBox answer = answerBoxes[i];
      answers.add(
        new PollAnswer(
          letter: answer.letter,
          answer: answer.controller.text.toString(),
          userIDs: List<String>.empty(growable: true),
        ),
      );
    }
    return answers;
  }
}
