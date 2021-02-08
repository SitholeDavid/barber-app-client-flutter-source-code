import 'package:barber_app_client/core/models/booking.dart';
import 'package:barber_app_client/core/utils.dart';
import 'package:barber_app_client/core/viewmodels/my_bookings_viewmodel.dart';
import 'package:barber_app_client/ui/constants/ui_helpers.dart';
import 'package:barber_app_client/ui/shared/colors.dart';
import 'package:barber_app_client/ui/shared/text_fonts.dart';
import 'package:barber_app_client/ui/widgets/booking_data_tile.dart';
import 'package:barber_app_client/ui/widgets/heading_tile.dart';
import 'package:barber_app_client/ui/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:stacked/stacked.dart';

class MyBookingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MyBookingsViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
            backgroundColor: backgroundSecondary,
            body: Stack(children: [
              Container(
                height: 300,
                width: double.infinity,
                margin: EdgeInsets.all(0),
                decoration: BoxDecoration(
                    color: backgroundPrimary,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.elliptical(30, 20),
                        bottomRight: Radius.elliptical(30, 20))),
              ),
              Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        largeSpace,
                        HeaderTileWidget(
                          heading: 'My bookings',
                        ),
                        mediumSpace,
                        Flexible(
                            child: ListView.builder(
                                itemCount: model.myBookings == null
                                    ? 0
                                    : model.myBookings.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                      onTap: () =>
                                          model.onBookingSelected(index),
                                      child:
                                          bookingTile(model.myBookings[index]));
                                }))
                      ])),
              loadingIndicator(model.isBusy, model.loadingText)
            ])),
        onModelReady: (model) => model.initialise(),
        viewModelBuilder: () => MyBookingsViewModel());
  }
}

Widget bookingTile(LocalBooking booking) {
  return Container(
    padding: EdgeInsets.all(8),
    margin: EdgeInsets.only(bottom: 20, left: 15, right: 15),
    decoration: BoxDecoration(boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 0,
        blurRadius: 3,
        offset: Offset(3, 3), // changes position of shadow
      )
    ], color: Colors.white, borderRadius: BorderRadius.circular(8)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20, top: 8),
          child: Text(
            booking.storeName,
            style: smallTextFont.copyWith(
                fontSize: 17,
                color: Colors.black87,
                fontWeight: FontWeight.w700),
          ),
        ),
        mediumSpace,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: horizontalSeparatorBar(),
        ),
        smallSpace,
        bookingDataTile(
            'Date', formatDatetime(booking.date), Icons.calendar_today),
        bookingDataTile('Time', booking.timeToString(), Icons.timer),
        bookingDataTile('Employee', booking.employeeName, AntDesign.user),
      ],
    ),
  );
}
