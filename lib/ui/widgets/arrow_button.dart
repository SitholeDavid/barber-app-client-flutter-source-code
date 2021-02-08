import 'package:barber_app_client/ui/shared/colors.dart';
import 'package:flutter/material.dart';

Widget forwardArrowButton(Function onTapCallback) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(5)),
    padding: EdgeInsets.all(6),
    child: IconButton(
        icon: Icon(
          Icons.arrow_forward,
          color: backgroundPrimary,
          size: 25,
        ),
        onPressed: onTapCallback),
  );
}

Widget backwardArrowButton(Function onTapCallback) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(5)),
    padding: EdgeInsets.all(6),
    child: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: backgroundPrimary,
          size: 25,
        ),
        onPressed: onTapCallback),
  );
}
