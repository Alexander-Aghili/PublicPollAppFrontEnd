import 'package:flutter/material.dart';
import 'package:public_poll/Mobile/Pages/CreatePollPages/AnswerBox.dart';
import 'package:public_poll/Models/Poll.dart';
import 'package:public_poll/Models/PollAnswer.dart';

class CreatePoll {
  // ignore: deprecated_member_use
  List<AnswerBox> answerBoxes;
  String question;
  bool isPrivatePoll;

  CreatePoll(
      {@required this.answerBoxes,
      @required this.question,
      @required this.isPrivatePoll});

  //Not needed but used, for organizational purposes
  Poll getPoll() {
    return createPoll();
  }

  Poll createPoll() {
    List<PollAnswer> answers = getAnswersFromAnswerBox();
    return Poll(pollQuestion: question, answers: answers);
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
        ),
      );
    }
    return answers;
  }
}
