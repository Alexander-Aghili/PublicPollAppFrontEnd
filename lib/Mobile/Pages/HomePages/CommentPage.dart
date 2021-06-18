import 'package:flutter/material.dart';
import 'package:public_poll/Mobile/Widgets/Essential/Header.dart';
import 'package:public_poll/Models/PollComment.dart';

/*
 * Copyright © 2021 Alexander Aghili - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Alexander Aghili alexander.w.aghili@gmail.com, May 2021
 */

class CommentPage extends StatelessWidget {
  List<PollComment> comments;

  CommentPage({@required this.comments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context: context, isAppTitle: false, title: "Comments", eliminateBackButton: false),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
