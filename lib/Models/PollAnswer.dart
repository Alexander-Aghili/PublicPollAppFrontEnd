import 'package:flutter/material.dart';
import 'package:public_poll/Models/Poll.dart';

/*
 * Copyright © 2021 Alexander Aghili - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Alexander Aghili alexander.w.aghili@gmail.com, May 2021
 */

class PollAnswer {
  String pollID;
  String answer;
  String letter;
  int numClicked;

  PollAnswer(
      {this.pollID,
      @required this.letter,
      @required this.answer,
      this.numClicked = 0});

  factory PollAnswer.fromJson(Map<String, dynamic> json, String pollID) {
    return PollAnswer(
      pollID: pollID,
      letter: json['letter'] as String,
      answer: json['answer'] as String,
      numClicked: json['numClicked'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'letter': letter,
    'answer': answer,
    'numClicked': numClicked,
  };

  @override
  String toString() {
    return answer;
  }
}
