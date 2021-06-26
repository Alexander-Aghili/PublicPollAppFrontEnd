/*
 * Copyright © 2021 Alexander Aghili - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Alexander Aghili alexander.w.aghili@gmail.com, May 2021
 */

import 'package:flutter/material.dart';

class User {
  String userID;
  String username;
  String email;
  DateTime birthday;
  String firstname;
  String lastname;
  String gender;
  String password;
  String profilePictureLink;
  List<String> savedPollsID;
  List<String> recentlyRespondedToPollsID;
  List<String> myPollsID;

  User({
    this.userID,
    @required this.username,
    @required this.email,
    @required this.birthday,
    @required this.firstname,
    @required this.lastname,
    @required this.gender,
    this.password,
    this.profilePictureLink,
    this.savedPollsID,
    this.recentlyRespondedToPollsID,
    this.myPollsID,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    DateTime getBirthdayFromJSON() {
      var birthdayObject = json['birthday'] as Map<String, dynamic>;
      int year = birthdayObject['year'];
      int month = birthdayObject['month'];
      int day = birthdayObject['day'];
      return DateTime(year, month, day);
    }

    //Probably a better way to do this but this is fine for now
    List<String> getListOfStringFromJSONArray(List<dynamic> list) {
      // ignore: deprecated_member_use
      List<String> tempList = List<String>();
      for (int i = 0; i < list.length; i++) {
        tempList.add(list[i] as String);
      }
      return tempList;
    }

    return User(
      userID: json['uid'],
      username: json['username'],
      email: json['email'],
      birthday: getBirthdayFromJSON(),
      firstname: json['firstname'],
      lastname: json['lastname'],
      gender: json['gender'],
      profilePictureLink: json['profilePicture'],
      savedPollsID:
          getListOfStringFromJSONArray(json['savedPolls'] as List<dynamic>),
      recentlyRespondedToPollsID:
          getListOfStringFromJSONArray(json['recentPolls'] as List<dynamic>),
      myPollsID: getListOfStringFromJSONArray(json['myPolls'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': userID,
        'username': username,
        'email': email,
        'birthday': getBirthdayString(),
        'firstname': firstname,
        'lastname': lastname,
        'gender': gender,
        'password': password,
        'profilePicture': profilePictureLink,
        /*TODO implement
        'savedPolls': getJSONListFromStringList(savedPollsID),
        'recentPolls': getJSONListFromStringList(recentlyRespondedToPollsID),
        'myPolls': getJSONListFromStringList(myPollsID),
        */
      };

  //TODO: implement
  String getJSONListFromStringList(List<String> list) {}

  Map<String, dynamic> getBirthdayString() {
    return {
      'year': birthday.year,
      'month': birthday.month,
      'day': birthday.day,
    };
  }
}
