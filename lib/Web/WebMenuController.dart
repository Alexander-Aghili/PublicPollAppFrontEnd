import 'package:flutter/material.dart';

class MenuController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldkey => _scaffoldKey;

  void controlMenu() {
    if (!_scaffoldKey.currentState.hasDrawer) {
      _scaffoldKey.currentState.openDrawer();
    }
  }
}
