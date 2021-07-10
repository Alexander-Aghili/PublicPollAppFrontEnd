import 'dart:convert';

import 'package:flutter/material.dart';

import 'PollAnswer.dart';
import 'PollComment.dart';

/*
 * Copyright © 2021 Alexander Aghili - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Alexander Aghili alexander.w.aghili@gmail.com, May 2021
 */

class Poll {
  String creatorID;
  String pollID;
  String pollQuestion;
  List<PollAnswer> answers;
  List<PollComment> comments;
  bool isPrivate;

  Poll(
      {this.pollID,
      @required this.creatorID,
      @required this.pollQuestion,
      @required this.answers,
      @required this.isPrivate,
      this.comments});

  factory Poll.fromJson(Map<String, dynamic> json) {
    String pollID = json['poll'] as String;

    List<PollAnswer> getAnswersFromJSON() {
      var pollAnswersJson = json['answers'] as List;
      List<PollAnswer> answers = pollAnswersJson
          .map((answerJson) => PollAnswer.fromJson(answerJson, pollID))
          .toList();
      return answers;
    }

    List<PollComment> getCommentsFromJSON() {
      var pollCommentsJson = json['comments'] as List;
      return pollCommentsJson
          .map((commentJson) => PollComment.fromJson(commentJson, pollID))
          .toList();
    }

    return Poll(
      creatorID: json['creatorID'],
      pollID: pollID,
      pollQuestion: json['question'],
      answers: getAnswersFromJSON(),
      comments: getCommentsFromJSON(),
      isPrivate: json['isPrivate'],
    );
  }

  Map<String, dynamic> toJson() => {
        'creatorID': creatorID,
        'question': pollQuestion,
        'answers': answers,
        'comments': comments,
        'isPrivate': isPrivate,
      };

  @override
  String toString() {
    return "pollID: " +
        pollID +
        "\nQuestion: " +
        pollQuestion +
        "\nAnswers: " +
        answers.toString() +
        "\nComments: " +
        comments.toString() +
        "\n";
  }
}
