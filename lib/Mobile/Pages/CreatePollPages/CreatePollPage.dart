import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:public_poll/Controller/Domain.dart';
import 'package:public_poll/Controller/PollRequests.dart';
import 'package:public_poll/Controller/UserController.dart';
import 'package:public_poll/Mobile/Pages/CreatePollPages/AnswerBox.dart';
import 'package:public_poll/Mobile/Widgets/Essential/Error.dart';
import 'package:public_poll/Mobile/Widgets/Essential/Header.dart';
import 'package:public_poll/Models/Poll.dart';
import 'package:share_plus/share_plus.dart';

import '../../../Style.dart';
import 'CreatePoll.dart';

/*
 * Copyright © 2021 Alexander Aghili - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Alexander Aghili alexander.w.aghili@gmail.com, May 2021
 */

Color contrastColor;
Size size;

// ignore: deprecated_member_use
List<Widget> answersComponents = List<Widget>();

class CreatePollPage extends StatefulWidget {
  final String userID;
  final Function freeze;
  final Function unFreeze;

  CreatePollPage(this.userID, this.freeze, this.unFreeze);

  @override
  State<StatefulWidget> createState() =>
      _CreatePollPage(userID, freeze, unFreeze);
}

class _CreatePollPage extends State<CreatePollPage> {
  String userID;
  bool isPriv;
  TextEditingController questionController = TextEditingController();

  Function freeze;
  Function unFreeze;

  _CreatePollPage(this.userID, this.freeze, this.unFreeze);

  @override
  void initState() {
    super.initState();
    isPriv = false;
    if (EasyLoading.isShow) EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    contrastColor =
        Theme.of(context).cupertinoOverrideTheme.primaryContrastingColor;
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: header(
          context: context,
          isAppTitle: false,
          title: "Create a Poll",
          eliminateBackButton: true,
          color: Theme.of(context).backgroundColor),
      body: ListView(
        physics: const ScrollPhysics(),
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //Question
              questionField(questionController),
              //Answers
              AddAnswers(),
              //Private Poll Button
              privatePollArea(),
              //Create Button
              createButton(),
            ],
          )
        ],
      ),
    );
  }

  Widget questionField(TextEditingController questionController) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: size.height * .05,
        horizontal: size.width * .05,
      ),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(width: 1, color: contrastColor),
          ),
          labelText: "Question",
        ),
        controller: questionController,
      ),
    );
  }

  Widget privatePollArea() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * .02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Checkbox(
            checkColor: Colors.white,
            activeColor: Colors.blue,
            value: isPriv,
            onChanged: (bool tempBool) {
              setState(() {
                isPriv = tempBool;
              });
            },
          ),
          Padding(padding: EdgeInsets.only(right: size.width * .005)),
          GestureDetector(
            onTap: () {
              setState(() {
                isPriv = !isPriv;
              });
            },
            child: Text(
              "Private Poll",
              style: Styles.baseTextStyle(
                  context, getFontSizeHorziontal(context, 35)),
            ),
          ),
        ],
      ),
    );
  }

  //Possible sizing issue
  Widget createButton() {
    return Container(
      margin: EdgeInsets.only(top: size.height * .05),
      width: size.width * .75,
      height: 25 + size.height * .025,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue)),
        onPressed: () => createNewPoll(),
        child: Text(
          "Create Poll",
          style: Styles.baseTextStyleWithColor(
              context, getFontSizeVertical(context, 30), Colors.white),
        ),
      ),
    );
  }

  /*
  This is quite stupid and should be changed when 
  I implement adding userID to the polls but rn just to get this done
  Im going to make two requests. First is to create, second is to add it to 
  users own polls.
  */
  void createNewPoll() async {
    if (EasyLoading.isShow) return;
    freeze();
    EasyLoading.show();
    //If fails, doesn't cause issues with answer adding and deleting
    // ignore: deprecated_member_use
    List<Widget> answerBoxes = List<Widget>();
    answerBoxes.addAll(answersComponents);
    answerBoxes.removeAt(answerBoxes.length - 1);

    CreatePoll createPoll = CreatePoll(
      uid: userID,
      question: questionController.text.toString(),
      answerBoxes: answerBoxes.cast<AnswerBox>(),
      isPrivatePoll: isPriv,
    );

    Poll poll = createPoll.getPoll();
    PollRequests requests = new PollRequests();
    String code = await requests.createPoll(poll);
    if (code.indexOf(" ") != -1) {
      EasyLoading.dismiss();
      unFreeze();
      errorMessage("Could not create poll");
    } else {
      poll.pollID = code;

      //Dumb and remove later
      UserController userController = UserController();
      await userController.addUserPolls(userID, code, 3);
      EasyLoading.dismiss();
      unFreeze();

      successMessage(poll);
    }
  }

  void errorMessage(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  errorIcon(40),
                ]),
            content: Text(
              message,
              style: TextStyle(fontSize: 20),
            ),
            actions: <Widget>[
              closeButton(),
            ],
          );
        });
  }

  /*
  * Issue with dialog where close overflows
  */
  void successMessage(Poll poll) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Poll Created!",
              style: TextStyle(fontSize: 35),
            ),
            content: Text("Your poll was created." +
                " You can share the poll by clicking the button at the bottom left." +
                " You can also find the poll in the My Polls section on the account page.", style: TextStyle(fontSize: 23.5),),
            actions: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    closeButton(),
                    Spacer(),
                    shareButton(poll),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Widget closeButton() {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text(
        'Close',
        style: Theme.of(context).dialogTheme.contentTextStyle,
      ),
    );
  }

  Widget shareButton(Poll poll) {
    Icon shareIcon;
    double iconSize = 30;
    if (kIsWeb || Platform.isAndroid) {
      shareIcon = Icon(Icons.share, size: iconSize);
    } else if (Platform.isIOS) {
      shareIcon = Icon(Icons.ios_share, size: iconSize);
    }
    return IconButton(
      icon: shareIcon,
      onPressed: () => Share.share(
          Domain.getWeb() + "pollDisplay?id=" + poll.pollID.toString()),
    );
  }
}

class AddAnswers extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddAnswers();
}

class _AddAnswers extends State<AddAnswers> {
  @override
  void initState() {
    super.initState();
    answersComponents = getDefaultComponents();
  }

  List<Widget> getDefaultComponents() {
    // ignore: deprecated_member_use
    List<Widget> components = List<Widget>();
    components.add(new AnswerBox(1));
    components.add(new AnswerBox(2));
    components.add(answerAdjustButton(Icon(Icons.add), addNewAnswerBox));
    return components;
  }

  Widget answerAdjustButton(Icon icon, Function function) {
    return FloatingActionButton(
      onPressed: () => function(),
      child: icon,
      backgroundColor: contrastColor,
    );
  }

  void addNewAnswerBox() {
    int componentsLength = answersComponents.length;
    if (componentsLength == 3) {
      createBothButtons();
    }
    setState(() {
      answersComponents.insert(
          componentsLength - 1, new AnswerBox(componentsLength));
    });
    if (componentsLength == 26) {
      setState(() {
        answersComponents.removeAt(componentsLength);
        answersComponents
            .add(answerAdjustButton(Icon(Icons.delete), deleteLastAnswer));
      });
    }
  }

  void deleteLastAnswer() {
    int componentsLength = answersComponents.length;
    if (componentsLength == 27) {
      createBothButtons();
    }
    setState(() {
      answersComponents.removeAt(componentsLength - 2);
    });
    if (componentsLength == 4) {
      removeSubtractButton();
    }
  }

  void createBothButtons() {
    //Removes only addButton
    answersComponents.removeAt(answersComponents.length - 1);
    answersComponents.add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        answerAdjustButton(Icon(Icons.delete), deleteLastAnswer),
        Padding(padding: EdgeInsets.symmetric(horizontal: size.width * .05)),
        answerAdjustButton(Icon(Icons.add), addNewAnswerBox),
      ],
    ));
  }

  void removeSubtractButton() {
    answersComponents.removeAt(answersComponents.length - 1);
    answersComponents.add(answerAdjustButton(Icon(Icons.add), addNewAnswerBox));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: answersComponents,
        ),
      ],
    );
  }
}
