import 'package:barber_app_client/ui/shared/text_fonts.dart';
import 'package:flutter/material.dart';

Widget bookingDataTile(String title, String subTitle, IconData icon) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: smallTextFont.copyWith(color: Colors.black45),
            ),
            Text(subTitle, style: smallTextFont.copyWith(color: Colors.black87))
          ],
        ),
        Icon(
          icon,
          color: Colors.black38,
          size: 25,
        )
      ],
    ),
  );
}
