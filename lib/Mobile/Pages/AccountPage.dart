import 'package:flutter/material.dart';
import 'package:public_poll/Themes.dart';

/*
 * Copyright © 2021 Alexander Aghili - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Alexander Aghili alexander.w.aghili@gmail.com, May 2021
 */

class AccountPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AccountPage();
}

class _AccountPage extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cupertinoOverrideTheme.barBackgroundColor,
    );
  }
}
