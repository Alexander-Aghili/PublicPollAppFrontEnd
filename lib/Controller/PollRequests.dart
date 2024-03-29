import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:public_poll/Controller/Domain.dart';
import 'package:public_poll/Models/Poll.dart';
import 'dart:async';
import 'dart:convert';

import 'package:public_poll/Models/PollComment.dart';
import 'UserController.dart';

class PollRequests {
  String url = Domain.getAPI() + 'poll/';
  /* GET Requests*/
  Future<Poll> getPollByID(String id) async {
    Response response = await http.get(Uri.parse(url + 'getPoll/' + id));

    if (response.statusCode == 200) {
      return Poll.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load poll');
    }
  }

  Future<List<Poll>> getPolls(String userID) async {
    Response response = await http.get(Uri.parse(url + 'getPolls/' + userID));
    if (response.statusCode == 200) {
      return listOfPolls(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load poll list');
    }
  }

  List<Poll> listOfPolls(Map<String, dynamic> json) {
    var pollsJson = json['polls'] as List;
    List<Poll> polls =
        pollsJson.map((pollJson) => Poll.fromJson(pollJson)).toList();
    return polls;
  }

  /* POST Requests */
  Future<String> createPoll(Poll poll) async {
    var requestHeaders =
        await getHeaders(); //getHeaders() method in UserController.dart

    Response response = await http.post(
      Uri.parse(url + "addPoll"),
      headers: requestHeaders,
      body: jsonEncode(poll),
    );

    int code = response.statusCode;
    String res = response.body;
    if (code != 201 || res.indexOf(" ") != -1) {
      return res.substring(res.indexOf("<title>") + 7, res.indexOf("</title>"));
    } else {
      return response.body;
    }
  }

  Future<List<Poll>> getPollsFromPollIDs(
      List<String> pollIDs, bool getTime) async {
    String body = '{ "pollIDs": ' + jsonEncode(pollIDs) + '}';
    Response response = await http.post(
      Uri.parse(url + "getPollsFromPollIDs"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    try {
      return listOfPolls(jsonDecode(response.body));
    } catch (e) {
      return List<Poll>.empty();
    }
  }

  Future<String> addComment(PollComment comment) async {
    var requestHeaders = await getHeaders();

    Response response = await http.post(
      Uri.parse(url + "addComment"),
      headers: requestHeaders,
      body: jsonEncode(comment.toJsonSend()),
    );
    if (response.statusCode != 201 || response.body.indexOf(" ") != -1) {
      return "error";
    } else {
      return response.body;
    }
  }

  Future<String> addUserResponseToPoll(
      String uid, String pollID, String letter) async {
    String json = '{"userID": "' +
        uid +
        '", "pollID": "' +
        pollID +
        '", "letter": "' +
        letter +
        '"}';

    var requestHeaders = await getHeaders();

    Response response = await http.post(
      Uri.parse(url + "addUserResponseToPoll"),
      headers: requestHeaders,
      body: json,
    );

    if (response.statusCode != 201 || response.body != "ok") {
      return "error";
    } else {
      return "ok";
    }
  }

  /*Delete*/
  Future<String> deletePoll(String userID, String pollID) async {
    var requestHeaders = await getHeaders();

    Response response = await http.delete(
        Uri.parse(url + "deletePoll/" + userID + '/' + pollID),
        headers: requestHeaders);

    if (response.statusCode != 202 || response.body != "ok") {
      return "error";
    } else {
      return "ok";
    }
  }

  Future<String> deleteComment(String userID, String id) async {
    var requestHeaders = await getHeaders();
    Response response = await http.delete(
        Uri.parse(url + "deleteComment/" + userID + '/' + id),
        headers: requestHeaders);

    if (response.statusCode != 202 || response.body != "ok") {
      return "error";
    } else {
      return "ok";
    }
  }
}
