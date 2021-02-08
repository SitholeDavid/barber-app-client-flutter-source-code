import 'dart:ui';

import 'package:barber_app_client/ui/shared/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final double textSizeSmall = 13;
final double textSizeMedium = 16;
final double textSizeLarge = 25;

final TextStyle headerTextFont = TextStyle(
    fontFamily: 'Futura',
    fontSize: 30,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
    color: Colors.white);

final TextStyle largeTextFont = GoogleFonts.roboto(
    fontWeight: FontWeight.bold, color: textSecondary, fontSize: textSizeLarge);

final TextStyle mediumTextFont = GoogleFonts.roboto(
    fontWeight: FontWeight.w400,
    color: textSecondary,
    fontSize: textSizeMedium);

final TextStyle smallTextFont = GoogleFonts.manrope(
    fontWeight: FontWeight.w400, color: textSecondary, fontSize: textSizeSmall);
