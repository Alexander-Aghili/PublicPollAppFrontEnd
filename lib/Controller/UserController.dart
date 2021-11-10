import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:public_poll/Controller/Domain.dart';
import 'package:public_poll/Controller/PollRequests.dart';
import 'package:public_poll/Models/KeyValue.dart';
import 'package:public_poll/Models/Poll.dart';
import 'package:public_poll/Models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<List<Poll>> getUserPoll(String userID, int type) async {
    String sid = await getSessionID();
    Response response = await http.get(
        Uri.parse(url + "getUserPoll/" + userID + "/" + type.toString()),
        headers: <String, String>{
          'Cookie': 'sid=' + sid,
        });
    if (response.statusCode == 200) {
      try {
        String jsonResponseString = response.body;
        Map<String, dynamic> json = jsonDecode(jsonResponseString);

        var pollInfo = json['pollInfo'] as List;
        List<KeyValue> orderKeyValues =
            new List<KeyValue>.empty(growable: true);

        for (int i = 0; i < pollInfo.length; i++) {
          String jsonObject = pollInfo[i].toString();
          String pollID = jsonObject.substring(1, jsonObject.indexOf(":"));
          int order = int.parse(jsonObject.substring(
              jsonObject.indexOf(" "), jsonObject.indexOf("}")));
          orderKeyValues.add(new KeyValue(pollID, order));
        }

        jsonResponseString = jsonResponseString.substring(
                0, jsonResponseString.indexOf('"pollInfo"') - 1) +
            "}";

        json = jsonDecode(jsonResponseString);

        PollRequests pollRequests = PollRequests();
        List<Poll> polls = pollRequests.listOfPolls(json);

        return sortPolls(orderKeyValues, polls);
      } catch (e) {
        return new List<Poll>.empty(growable: true);
      }
    } else {
      throw Exception("User Poll Error");
    }
  }

  List<Poll> sortPolls(List<KeyValue> orderPairs, List<Poll> polls) {
    List<Poll> orderedPolls = new List<Poll>.empty(growable: true);

    for (int i = 0; i < polls.length; i++) {
      String pollID =
          orderPairs[orderPairs.indexWhere((element) => element.value == i)]
              .key;
      Poll poll =
          polls[polls.indexWhere((element) => element.pollID == pollID)];

      orderedPolls.add(poll);
    }

    return orderedPolls;
  }

  Future<bool> resetPasswordInitRequest(String email) async {
    Response response =
        await http.get(Uri.parse(url + "/resetPasswordInitRequest/" + email));

    print(response.body);
    if (response.statusCode == 200 && response.body == "Success") {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> report(String userID, String pollOrCommentID) async {
    Response response = await http.get(Uri.parse(
        Domain.getAPI() + 'contact/report/' + userID + '/' + pollOrCommentID));

    if (response.statusCode == 200)
      return true;
    else
      return false;
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
    if (response.statusCode == 201) {
      return await parseSignInResponse(jsonDecode(response.body.toString()));
    } else {
      return 'regular error';
    }
  }

  Future<String> verifyCreateUserInfo(String email, String username) async {
    // ignore: non_constant_identifier_names
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
    // ignore: non_constant_identifier_names
    String JSONFormat =
        jsonFormatWithTwoComponents("username", username, "password", password);

    Response response = await http.post(Uri.parse(url + "login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSONFormat);

    if (response.statusCode == 201) {
      return await parseSignInResponse(jsonDecode(response.body.toString()));
    } else {
      return "regular error";
    }
  }

  //Returns UID, sets SID
  Future<String> parseSignInResponse(Map<String, dynamic> json) async {
    if (json['error'] != "false") {
      return json['error'];
    }

    String sid = json['sessionID'];
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("SessionID", sid);
    return json['userID'];
  }

  Future<bool> logout(String userID) async {
    var requestHeaders = await getHeaders();

    Response response = await http.post(Uri.parse(url + "logout"),
        headers: requestHeaders, body: '{"userID":"' + userID + '"}');

    if (response.statusCode != 201 || response.body != "Success")
      return false;
    else
      return true;
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

    var requestHeaders = await getHeaders();

    Response response = await http.post(Uri.parse(url + "addUserPolls"),
        headers: requestHeaders, body: jsonEncode(json));
    if (response.statusCode != 201 || response.body != "ok") {
      return "error";
    } else {
      return response.body;
    }
  }

  Future<String> uploadProfileImage(
      File file, String userID, bool needReplace) async {
    var stream = http.ByteStream(file.openRead());
    stream.cast();
    Uint8List bytes = await stream.toBytes();

    var requestHeaders = await getHeaders(
        customContentType: 'application/octet-stream; charset=UTF-8');

    Response response = await http
        .post(
          Uri.parse(url +
              "uploadProfilePicture/" +
              userID +
              "/" +
              needReplace.toString()),
          headers: requestHeaders,
          body: bytes,
        )
        .timeout(Duration(seconds: 5));

    if (response.statusCode != 201) {
      EasyLoading.dismiss();
      return "Error";
    } else {
      return "";
    }
  }

  Future<String> editUserInformation(
      String userID, List<KeyValue> keyValuePairs) async {
    String json = '{"userID": "' + userID + '",';
    for (int i = 0; i < keyValuePairs.length; i++) {
      json += keyValuePairs[i].toJson() + ",";
    }
    json = json.substring(0, json.length - 1) + "}";

    Response response = await http.post(Uri.parse(url + "editUser"),
        headers: await getHeaders(), body: json);
    if (response.statusCode != 201) {
      return "error";
    } else {
      return response.body;
    }
  }

  /* @DELETE */
  Future<String> deleteUserPoll(String userID, String pollID, int type) async {
    Response response = await http.delete(
        Uri.parse(url +
            "deleteUserPoll/" +
            pollID +
            "/" +
            userID +
            "/" +
            type.toString()),
        headers: await getHeaders());
    if (response.statusCode != 202 || response.body != "ok") {
      return "error";
    } else {
      return "ok";
    }
  }

  Future<bool> deleteUser(String userID) async {
    var requestHeaders = await getHeaders();
    Response response = await http.delete(
        Uri.parse(url + "deleteUser/" + userID),
        headers: requestHeaders);

    if (response.statusCode == 202 && response.body == "ok") {
      return true;
    } else {
      return false;
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

Future<Map<String, String>> getHeaders({String customContentType}) async {
  String sid = await getSessionID();
  String contentType;

  if (customContentType == null)
    contentType = 'application/json; charset=UTF-8';
  else
    contentType = customContentType;

  Map<String, String> requestHeaders = {
    'Content-type': contentType,
    'Cookie': 'sid=' + sid,
  };
  return requestHeaders;
}

Future<String> getSessionID() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString("SessionID");
}
