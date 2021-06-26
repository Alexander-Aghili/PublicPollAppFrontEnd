import 'package:flutter/material.dart';
import 'package:public_poll/Models/User.dart';

//TODO: Do
class EditAccountPage extends StatefulWidget {
  User user;

  EditAccountPage(this.user);

  @override
  State<StatefulWidget> createState() => _EditAccountPage(user);
}

class _EditAccountPage extends State<EditAccountPage> {
  User user;
  _EditAccountPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
