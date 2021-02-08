import 'package:barber_app_client/ui/shared/colors.dart';
import 'package:barber_app_client/ui/shared/text_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget customInputField(
    {String fieldTitle,
    TextEditingController controller,
    TextInputType inputType,
    String hintText,
    Function validator}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8),
    height: 110,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fieldTitle,
          style: smallTextFont,
        ),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: inputType,
          style: smallTextFont.copyWith(
              color: Colors.white, letterSpacing: 1.25, fontSize: 15),
          obscureText:
              inputType == TextInputType.visiblePassword ? true : false,
          decoration: InputDecoration(
              hintStyle: smallTextFont.copyWith(
                  color: Colors.white60, letterSpacing: 1.25),
              hintText: hintText ?? '',
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red[600])),
              disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey))),
        )
      ],
    ),
  );
}

Widget customInputFieldDark(
    {String fieldTitle,
    TextEditingController controller,
    TextInputType inputType,
    String hintText,
    Function validator}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    margin: EdgeInsets.all(0),
    height: 70,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fieldTitle,
          style: smallTextFont.copyWith(color: Colors.black54),
        ),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: inputType,
          style: smallTextFont.copyWith(
              color: Colors.white, letterSpacing: 1.25, fontSize: 15),
          obscureText:
              inputType == TextInputType.visiblePassword ? true : false,
          decoration: InputDecoration(
              hintStyle: smallTextFont.copyWith(
                  color: Colors.black38, letterSpacing: 1.25),
              hintText: hintText ?? '',
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              enabledBorder:
                  UnderlineInputBorder(borderSide: BorderSide(color: accent)),
              errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red[600])),
              disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey))),
        )
      ],
    ),
  );
}
