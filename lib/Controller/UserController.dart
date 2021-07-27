import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:public_poll/Controller/Domain.dart';
import 'package:public_poll/Models/User.dart';

class UserController {
  String url = Domain.getAPI() + 'users/';

  /* GET Requests*/

  Future<User> getUserByID(String id) async {
    Response response = await http.get(Uri.parse(url + 'getUserByID/' + id));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error");
    }
  }

  Future<bool> checkUserPollExists(
      String userID, String pollID, int type) async {
    Response response = await http.get(Uri.parse(url +
        "checkUserPoll/" +
        pollID +
        "/" +
        userID +
        "/" +
        type.toString()));
    if (response.statusCode == 200) {
      String boolString = response.body;
      if (boolString == "true") {
        return true;
      } else {
        return false;
      }
    } else {
      throw Exception("Couldn't load if user poll exists");
    }
  }

  /* POST Requests */

  Future<String> createUser(User user) async {
    Response response = await http.post(
      Uri.parse(url + "createUser"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user),
    );
    return response.body;
  }

  Future<String> verifyCreateUserInfo(String email, String username) async {
    String JSONFormat =
        jsonFormatWithTwoComponents("email", email, "username", username);

    Response response = await http.post(Uri.parse(url + "verify"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSONFormat);
    return response.body.toString();
  }

  Future<String> signInWithUsernameAndPassword(
      String username, String password) async {
    String JSONFormat =
        jsonFormatWithTwoComponents("username", username, "password", password);
    Response response = await http.post(Uri.parse(url + "signInUsername"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSONFormat);
    return response.body.toString();
  }

  Future<List<User>> getUsersFromIDs(List<String> uids) async {
    Response response = await http.post(Uri.parse(url + "getUsers"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: "{ \"userIDs\": " + jsonEncode(uids) + "}");

    if (response.statusCode != 201) {
      return new List<User>.empty(growable: true);
    }
    return listOfUsers(jsonDecode(response.body));
  }

  List<User> listOfUsers(Map<String, dynamic> json) {
    var usersJson = json['users'] as List;
    return usersJson.map((userJson) => User.fromJson(userJson)).toList();
  }

  Future<String> addUserPolls(String uid, String pollID, int type) async {
    Map<String, dynamic> json = {
      'userID': uid,
      'pollID': pollID,
      'type': type,
    };
    Response response = await http.post(Uri.parse(url + "addUserPolls"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(json));
    if (response.statusCode != 201 || response.body != "ok") {
      return "error";
    } else {
      return response.body;
    }
  }

  /* @DELETE */
  Future<String> deleteUserPoll(String userID, String pollID, int type) async {
    Response response = await http.delete(Uri.parse(url +
        "deleteUserPoll/" +
        pollID +
        "/" +
        userID +
        "/" +
        type.toString()));
    if (response.statusCode != 202 || response.body != "ok") {
      return "error";
    } else {
      return "ok";
    }
  }
}

String jsonFormatWithTwoComponents(
    String first, String firstElement, String second, String secondElement) {
  return "{ \"" +
      first +
      "\": \"" +
      firstElement +
      "\", \"" +
      second +
      "\": \"" +
      secondElement +
      "\"}";
}
