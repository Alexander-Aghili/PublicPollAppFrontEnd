import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:public_poll/Themes.dart';
import 'Authentication/AuthDetection.dart';

/*
 * Copyright © 2021 Alexander Aghili - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Alexander Aghili alexander.w.aghili@gmail.com, May 2021
 */

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Public Polling',
      theme: lightMode(),
      darkTheme: darkMode(),
      themeMode: ThemeMode.system,
      home: AuthDetection(),
      debugShowCheckedModeBanner: false,
    );
  }
}
