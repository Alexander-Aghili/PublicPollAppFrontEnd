import 'package:flutter/material.dart';
import 'package:public_poll/Models/Poll.dart';

import 'User.dart';

/*
 * Copyright © 2021 Alexander Aghili - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Alexander Aghili alexander.w.aghili@gmail.com, May 2021
 */

class PollComment {
  String pollID;
  int commentID;
  String comment;
  /* Change to User object*/
  String user;

  PollComment(
      {this.pollID,
      @required this.comment,
      @required this.user,
      this.commentID});

  factory PollComment.fromJson(Map<String, dynamic> json, String pollID) {
    return PollComment(
      pollID: pollID,
      comment: json['comment'] as String,
      user: json['user'] as String,
      commentID: json['commentID'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'comment': comment,
    'user': user,
    'commentID': commentID,
  };

  @override
  String toString() {
    return "Comment: " + comment;
  }
}
