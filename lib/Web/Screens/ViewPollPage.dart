import 'package:flutter/material.dart';
import 'package:public_poll/Responsive.dart';
import 'package:public_poll/Web/Components/PollDisplay.dart';
import 'package:public_poll/Web/WebMenuController.dart';
import 'package:provider/provider.dart';

class ViewPollPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Row(
        children: <Widget>[
          if (!Responsive.isDesktop(context))
            GestureDetector(
              onTap: null,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () => {
                          context.read<MenuController>().controlMenu(),
                        }),
              ),
            ),
        ],
      ),
    );
  }
}
