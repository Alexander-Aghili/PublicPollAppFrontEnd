import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:public_poll/Models/Poll.dart';
import 'dart:async';
import 'dart:convert';

class PollRequests {
  String url = 'http://192.168.87.118:8081/PublicPollBackEnd/publicpoll/poll/';
  /* GET Requests*/
  Future<Poll> getPollByID(String id) async {
    Response response = await http.get(Uri.parse(url + 'getPoll/' + id));

    if (response.statusCode == 200) {
      return Poll.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load poll');
    }
  }

  Future<List<Poll>> getPolls() async {
    Response response = await http.get(Uri.parse(url + 'getPolls'));

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
    Response response = await http.post(
      Uri.parse(url + "addPoll"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
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

  Future<List<Poll>> getPollsFromPollIDs(List<String> pollIDs) async {
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
}
