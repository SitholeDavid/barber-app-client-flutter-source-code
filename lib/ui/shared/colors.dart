import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

final Color backgroundPrimary = HexColor('#202346');
final Color backgroundSecondary = HexColor('#f2f4ff');
final Color accent = HexColor('#37AFFF');
final Color textPrimary = HexColor('#131313');
final Color textSecondary = HexColor('#8B8B8B');

final LinearGradient fewClientsGradient = LinearGradient(colors: [
  Colors.lightGreen[300],
  Colors.lightGreen,
  Colors.lightGreen[300]
]);

final LinearGradient averageClientsGradient = LinearGradient(
    colors: [Colors.orange[300], Colors.orange[500], Colors.orange[300]]);

final LinearGradient highClientsGradient =
    LinearGradient(colors: [Colors.red[300], Colors.red[500], Colors.red[300]]);

final LinearGradient notWorkingGradient = LinearGradient(
    colors: [Colors.grey[350], Colors.grey[400], Colors.grey[350]]);
