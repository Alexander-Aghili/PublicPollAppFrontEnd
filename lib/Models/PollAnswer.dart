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
  List<String> userIDs;

  PollAnswer(
      {this.pollID,
      @required this.letter,
      @required this.answer,
      @required this.userIDs});

  factory PollAnswer.fromJson(Map<String, dynamic> json, String pollID) {
    List<String> getUserIDs() {
      if (json['users'].toString() == "[]") {
        return new List<String>.empty();
      }
      List<String> userIDList = new List<String>.empty(growable: true);
      List<dynamic> usersList = json['users'] as List<dynamic>;
      for (int i = 0; i < usersList.length; i++) {
        userIDList.add(usersList[i].toString());
      }
      return userIDList;
    }

    return PollAnswer(
      pollID: pollID,
      letter: json['letter'] as String,
      answer: json['answer'] as String,
      userIDs: getUserIDs(), // Might not work
    );
  }

  Map<String, dynamic> toJson() => {
        'letter': letter,
        'answer': answer,
        'users': userIDs,
      };

  @override
  String toString() {
    return answer;
  }
}
