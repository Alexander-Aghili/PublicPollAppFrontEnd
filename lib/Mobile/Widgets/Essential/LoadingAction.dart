import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

circularProgress() {

  if (!kIsWeb && Platform.isIOS) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 12.0),
      child: CupertinoActivityIndicator(
        animating: true,
        radius: 15,
      ),
    );
  }
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12.0),
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.lightGreen),
    ),
  );
}

linearProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 12.0),
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.lightGreen),
    ),
  );
}
