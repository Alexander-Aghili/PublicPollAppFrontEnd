import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:public_poll/Models/User.dart';

Future<Image> getUserProfilePicture(User user) async {

  if (user.profilePictureLink == null || user.profilePictureLink == "") {
    return Image.asset("assets/images/default_user_image.jpg");
  }
  HttpClient client = HttpClient();
  HttpClientRequest request =
      await client.getUrl(Uri.parse(user.profilePictureLink));
  HttpClientResponse response = await request.close();
  Uint8List bytes = await consolidateHttpClientResponseBytes(response);
  return Image.memory(bytes);
}

Future<CircleAvatar> getAvatarFromUser(User user, double radius) async {
  Image image = await getUserProfilePicture(user);
  return getAvatar(image, radius, false);
}

CircleAvatar getAvatar(Image image, double radius, bool camera) {
  if (camera) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: image.image,
      child: Icon(Icons.camera_alt, color: Colors.white,),
    );
  }
  return CircleAvatar(
    radius: radius,
    backgroundImage: image.image,
  );
}

CircleAvatar waitingAvatar(double radius, BuildContext context) {
  return CircleAvatar(
    radius: radius,
    backgroundColor:
        Theme.of(context).cupertinoOverrideTheme.barBackgroundColor,
  );
}

