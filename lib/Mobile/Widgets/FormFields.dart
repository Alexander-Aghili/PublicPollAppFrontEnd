/*
  Field Area for each TextFormField, is stored in a list from main page.
*/
import 'package:flutter/material.dart';

EdgeInsets defaultFormPadding(Size size) {
  return EdgeInsets.symmetric(
    vertical: size.height * .015,
    horizontal: size.width * .05,
  );
}

class FieldArea extends StatelessWidget {
  final TextFormField field;
  final Size size;

  FieldArea(this.size, {@required this.field});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: defaultFormPadding(size),
      child: field,
    );
  }
}

TextFormField createField(bool secureText, TextEditingController controller,
    String inputText, Function validator, {String initialText}) {
  if (initialText != null) controller.text = initialText;

  return TextFormField(
    obscureText: secureText,
    controller: controller,
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: inputText,
    ),
    validator: (value) => validator(value),
  );
}
