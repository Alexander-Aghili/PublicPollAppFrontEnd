import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AnswerBox extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  String letter;

  AnswerBox(numBox) {
    letter = String.fromCharCode(numBox + 64);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Color contrastColor =
        Theme.of(context).cupertinoOverrideTheme.primaryContrastingColor;
    return Container(
      padding: EdgeInsets.only(
          left: size.width * .05,
          right: size.width * .05,
          bottom: size.height * .025),
      child: TextField(
        decoration: InputDecoration(
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              borderSide: BorderSide(width: 1, color: contrastColor),
            ),
            labelText: letter + ")"),
        controller: controller,
      ),
    );
  }
}
