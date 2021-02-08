import 'package:barber_app_client/ui/constants/ui_helpers.dart';
import 'package:barber_app_client/ui/shared/colors.dart';
import 'package:barber_app_client/ui/shared/text_fonts.dart';
import 'package:flutter/material.dart';

Widget customButton(String buttonTitle, Function onTapCallback) {
  return Column(
    children: [
      mediumSpace,
      FlatButton(
          onPressed: onTapCallback,
          padding: EdgeInsets.all(0),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: accent.withOpacity(0.95),
                borderRadius: BorderRadius.circular(8)),
            width: double.infinity,
            height: 60,
            child: Text(
              buttonTitle,
              style: mediumTextFont.copyWith(
                  letterSpacing: 1.25,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 17),
              textAlign: TextAlign.center,
            ),
          )),
    ],
  );
}

Widget customButtonDark(String buttonTitle, Function onTapCallback) {
  return Column(
    children: [
      smallSpace,
      FlatButton(
          onPressed: onTapCallback,
          padding: EdgeInsets.all(8),
          child: Container(
            width: 260,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: backgroundPrimary,
                borderRadius: BorderRadius.circular(10)),
            height: 45,
            child: Text(
              buttonTitle,
              style: mediumTextFont.copyWith(
                  letterSpacing: 1.25,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 13),
              textAlign: TextAlign.center,
            ),
          )),
    ],
  );
}

Widget customButtonDarkLarge(
    String buttonTitle, Function onTapCallback, bool isEnabled) {
  return Column(
    children: [
      smallSpace,
      FlatButton(
          onPressed: isEnabled ? onTapCallback : null,
          padding: EdgeInsets.all(8),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: isEnabled ? backgroundPrimary : Colors.grey,
                borderRadius: BorderRadius.circular(10)),
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              buttonTitle,
              style: mediumTextFont.copyWith(
                  letterSpacing: 1.25,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 13),
              textAlign: TextAlign.center,
            ),
          )),
    ],
  );
}
