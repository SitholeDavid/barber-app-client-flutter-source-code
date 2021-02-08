import 'package:barber_app_client/core/models/booking_data.dart';
import 'package:barber_app_client/ui/constants/enums.dart';
import 'package:barber_app_client/ui/constants/ui_helpers.dart';
import 'package:barber_app_client/ui/shared/colors.dart';
import 'package:barber_app_client/ui/shared/text_fonts.dart';
import 'package:barber_app_client/ui/widgets/booking_data_tile.dart';
import 'package:barber_app_client/ui/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../locator.dart';

void setupDialogUi() {
  final dialogService = locator<DialogService>();

  final builders = {
    DialogType.bookingSuccessful: (context, sheetRequest, completer) =>
        _BookingSuccessfulDialog(request: sheetRequest, completer: completer)
  };

  dialogService.registerCustomDialogBuilders(builders);
}

class _BookingSuccessfulDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  BookingData bookingData;
  _BookingSuccessfulDialog({Key key, this.request, this.completer})
      : super(key: key) {
    this.bookingData = request.customData as BookingData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.15),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 15),
        margin: EdgeInsets.symmetric(vertical: 55, horizontal: 25),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            largeSpace,
            CircleAvatar(
              backgroundColor: backgroundPrimary.withOpacity(0.15),
              radius: 45,
              child: Icon(
                MaterialCommunityIcons.calendar_check,
                size: 55,
                color: backgroundPrimary,
              ),
            ),
            largeSpace,
            Text(
              'Booking Successful',
              style: mediumTextFont.copyWith(
                  fontSize: 21,
                  color: backgroundPrimary,
                  fontWeight: FontWeight.w600),
            ),
            mediumSpace,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Your booking has been successful, please arrive at least 15 minutes before your booking.',
                textAlign: TextAlign.center,
                style: smallTextFont,
              ),
            ),
            mediumSpace,
            horizontalSeparatorBar(),
            smallSpace,
            bookingDataTile(
                'Employee', bookingData.employeeName, AntDesign.user),
            smallSpace,
            horizontalSeparatorBar(),
            smallSpace,
            bookingDataTile('Date', bookingData.date, AntDesign.calendar),
            smallSpace,
            horizontalSeparatorBar(),
            smallSpace,
            bookingDataTile('Time', bookingData.time, EvilIcons.clock),
            smallSpace,
            horizontalSeparatorBar(),
            Expanded(child: Text('')),
            customButtonDarkLarge(
                'Got it', () => completer(DialogResponse()), true),
            smallSpace
          ],
        ),
      ),
    );
  }
}
