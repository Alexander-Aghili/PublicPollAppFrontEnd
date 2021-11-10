import 'package:flutter/material.dart';
import 'package:public_poll/Mobile/HomePage.dart';
import 'package:public_poll/Mobile/Pages/RoutedPages/SinglePollViewPage.dart';
import 'package:public_poll/Routing/RoutingConstants.dart';

Route<dynamic> generateRoute(
  RouteSettings settings,
) {
  String link;

  try {
    link = settings.name.substring(0, settings.name.indexOf("?"));
  } catch (e) {
    link = settings.name;
  }

  switch (link) {
    case HomeViewRoute:
      return MaterialPageRoute(builder: (context) => HomePage(null));

    case SinglePollViewRoute:
      final pollID = Uri.parse(settings.name).queryParameters['id'];
      return MaterialPageRoute(
          builder: (context) => SinglePollViewPage(pollID));

    default:
      return MaterialPageRoute(builder: (context) => HomePage(null));
  }
}
