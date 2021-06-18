import 'package:flutter/material.dart';
import 'package:public_poll/Mobile/Widgets/Essential/Header.dart';
import 'package:public_poll/Models/Poll.dart';

/*
 * Copyright © 2021 Alexander Aghili - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Alexander Aghili alexander.w.aghili@gmail.com, May 2021
 */

class StatisticsPage extends StatelessWidget {
  Poll poll;

  StatisticsPage({@required this.poll});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(
          context: context,
          isAppTitle: false,
          title: "Statistics",
          eliminateBackButton: false),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
