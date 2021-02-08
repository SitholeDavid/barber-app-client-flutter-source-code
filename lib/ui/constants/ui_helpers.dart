import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final Widget smallSpace = SizedBox(
  height: 5,
);

final Widget mediumSpace = SizedBox(
  height: 15,
);

final Widget largeSpace = SizedBox(
  height: 30,
);

final Widget extraLargeSpace = SizedBox(
  height: 70,
);

final Widget emptySpace = SizedBox(
  height: 0,
);

String limitStringSize(String sentence, int limit) {
  if (sentence.length <= limit) return sentence;

  return sentence.substring(0, limit).padRight(limit + 3, '.');
}

Widget horizontalSeparatorBar() => Container(
      width: double.infinity,
      height: 0.35,
      color: Colors.black45,
      child: Text(''),
    );

Widget dashedHorizontalSeparatorBar() {
  Path customPath = Path()
    ..moveTo(0, 0)
    ..lineTo(0, 10000);

  return DottedBorder(
      customPath: (size) => customPath, // PathBuilder
      color: Colors.black45,
      dashPattern: [8, 4],
      strokeWidth: 0.35,
      child: SizedBox(
        height: 1,
        width: double.infinity,
      ));
}
