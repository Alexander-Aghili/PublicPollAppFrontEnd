import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:public_poll/Mobile/HomePage.dart';
import 'package:provider/provider.dart';

import 'SignInPage.dart';

class AuthDetection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AuthDetection();
}

class _AuthDetection extends State<AuthDetection> {
  @override
  Widget build(BuildContext context) {
    return SignInPage();
  }
}
