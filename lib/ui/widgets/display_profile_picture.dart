import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

Widget displayProfilePicture(
    String profilePicUrl, File localImage, Function onTapCallback) {
  const double imageHeight = 50;

  var chosenImage = localImage == null
      ? CircleAvatar(
          child: Icon(
            Feather.camera,
            size: imageHeight,
          ),
          backgroundColor: Colors.transparent,
        )
      : Image.file(
          localImage,
          height: imageHeight,
        );

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: FlatButton(
        onPressed: onTapCallback,
        child: Container(
          margin: EdgeInsets.only(bottom: 30),
          alignment: Alignment.centerLeft,
          child: profilePicUrl == ''
              ? chosenImage
              : Image.network(
                  profilePicUrl,
                  height: imageHeight,
                ),
        )),
  );
}
