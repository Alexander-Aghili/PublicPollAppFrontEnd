import 'package:flutter/material.dart';
import 'package:public_poll/Controller/UserController.dart';
import 'package:public_poll/Mobile/Widgets/Essential/Header.dart';
import 'package:public_poll/Mobile/Widgets/Essential/LoadingAction.dart';
import 'package:public_poll/Models/PollComment.dart';
import 'package:public_poll/Models/User.dart';

/*
 * Copyright © 2021 Alexander Aghili - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Alexander Aghili alexander.w.aghili@gmail.com, May 2021
 */

class CommentPage extends StatelessWidget {
  List<PollComment> comments;

  Future<List<User>> getUsers() async {
    if (comments.isEmpty) {
      return new List<User>.empty(growable: true);
    }

    UserController controller = UserController();
    List<String> userIDs = List<String>.empty(growable: true);
    for (int i = 0; i < comments.length; i++) {
      userIDs.add(comments[i].user);
    }
    await controller.getUsersFromIDs(userIDs);
  }

  CommentPage({@required this.comments});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: header(
          context: context,
          isAppTitle: false,
          title: "Comments",
          eliminateBackButton: false),
      backgroundColor: Theme.of(context).primaryColor,
      body: FutureBuilder(
        future: getUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              physics: const ScrollPhysics(),
              children: [
                
              ],
            );
          }
          return Padding(
            padding: EdgeInsets.only(bottom: size.height * .15),
            child: circularProgress(),
          );
        },
      ),
    );
  }
}
