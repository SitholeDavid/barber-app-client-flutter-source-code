import 'package:barber_app_client/core/models/employee.dart';
import 'package:barber_app_client/core/utils.dart';
import 'package:barber_app_client/core/viewmodels/booking_viewmodel.dart';
import 'package:barber_app_client/ui/constants/margins.dart';
import 'package:barber_app_client/ui/constants/ui_helpers.dart';
import 'package:barber_app_client/ui/shared/colors.dart';
import 'package:barber_app_client/ui/shared/text_fonts.dart';
import 'package:barber_app_client/ui/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:stacked/stacked.dart';

class BookingView extends StatelessWidget {
  final ActiveEmployee employee;
  BookingView({this.employee});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BookingViewModel>.reactive(
        onModelReady: (model) async => await model.initialise(employee),
        builder: (context, model, child) => Scaffold(
              backgroundColor: backgroundSecondary,
              body: model.isBusy
                  ? loadingIndicatorLight(true, model.loadingText)
                  : Stack(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(
                              bottom: 90,
                              left: pageHorizontalMargin,
                              right: pageHorizontalMargin,
                              top: pageVerticalMargin),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                largeSpace,
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 7),
                                  child: Text(
                                    'Create booking  -  step ${model.currentStep + 1}',
                                    style: headerTextFont.copyWith(
                                        fontSize: 22, color: backgroundPrimary),
                                  ),
                                ),
                                model.currentStep == 0
                                    ? servicePicker(model)
                                    : emptySpace,
                                model.currentStep == 1
                                    ? datePicker(model)
                                    : emptySpace,
                                model.currentStep == 1
                                    ? timeSlotPicker(model)
                                    : emptySpace,
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 20,
                            left: 0,
                            right: 0,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  model.currentStep != 0
                                      ? navButton(model.prevStep, true)
                                      : mediumSpace,
                                  model.currentStep == 1
                                      ? bookButton(
                                          model.book, model.canGoToNextStep)
                                      : navButton(
                                          model.nextStep, model.canGoToNextStep,
                                          isBackButton: false)
                                ],
                              ),
                            )),
                      ],
                    ),
            ),
        viewModelBuilder: () => BookingViewModel());
  }

  Widget servicePicker(BookingViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        mediumSpace,
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Please pick one or more services offered by the selected employee below.',
            style: smallTextFont.copyWith(
                color: Colors.black45, letterSpacing: 1.1),
          ),
        ),
        largeSpace,
        ListView.builder(
          padding: EdgeInsets.all(0),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            var service = model.availableServices[index];

            return GestureDetector(
              onTap: () => model.updateSelectedServices(index),
              child: serviceTile(
                  service.title, service.price, model.selectedServices[index]),
            );
          },
          itemCount: model.availableServices == null
              ? 0
              : model.availableServices.length,
        ),
        mediumSpace,
      ],
    );
  }
}

Widget datePicker(BookingViewModel model) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      mediumSpace,
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Pick a date.',
          style: mediumTextFont.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              fontSize: 15,
              letterSpacing: 1.25),
        ),
      ),
      SizedBox(
        height: 90,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: model.bookingDays == null ? 0 : model.bookingDays.length,
            itemBuilder: (context, index) {
              var day = model.bookingDays[index];
              bool isSelected = day == model.selectedDay;
              return GestureDetector(
                onTap: () => model.onBookingDaySelected(index),
                child: dateTile(day, isSelected),
              );
            }),
      ),
      mediumSpace,
    ],
  );
}

Widget timeSlotPicker(BookingViewModel model) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      mediumSpace,
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          model.selectedDay == null
              ? ''
              : (model.bookingSlots.isNotEmpty
                  ? '..and a time slot.'
                  : 'Employee is not working on this day'),
          style: mediumTextFont.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              fontSize: 15,
              letterSpacing: 1.25),
        ),
      ),
      Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          children: model.bookingSlots == null
              ? []
              : model.bookingSlots.map((slot) {
                  bool isAvailable = slot.bookingID.isEmpty ||
                      slot.clientID == model.client.clientID;

                  bool isSelected = slot.clientID.isNotEmpty;

                  return GestureDetector(
                      /*    onLongPress:  () {
                        var booking = model.bookingSlots
                            .firstWhere((element) => element == slot);

                        if (booking.bookingID.isEmpty) return;

                        model.cancelBooking(booking.slotID);
                      },
                  */
                      onTap: () {
                        int index = model.bookingSlots.indexWhere((element) =>
                            element.timeToString() == slot.timeToString());

                        model.onSlotSelected(index);
                      },
                      child: slotTile(
                          slot.timeToString(), isSelected, isAvailable));
                }).toList(),
        ),
      ),
      mediumSpace,
    ],
  );
}

Widget navButton(Function onTapCallback, bool nextStepActive,
    {bool isBackButton = true}) {
  List<Widget> children = [
    SizedBox(
      width: 15,
    ),
    Text(
      isBackButton ? 'Prev step' : 'Next step',
      style: smallTextFont.copyWith(color: Colors.white),
    ),
    SizedBox(
      width: 10,
    ),
    Icon(
      isBackButton ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
      color: Colors.white,
    ),
    SizedBox(
      width: 15,
    ),
  ];

  return GestureDetector(
    onTap: nextStepActive ? onTapCallback : null,
    child: Container(
      height: 50,
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: nextStepActive ? backgroundPrimary : Colors.grey),
      child: Row(
        children: isBackButton ? children.reversed.toList() : children,
      ),
    ),
  );
}

Widget bookButton(Function onTapCallback, bool isActive) {
  return GestureDetector(
    onTap: isActive ? onTapCallback : null,
    child: Container(
      height: 50,
      width: 140,
      alignment: Alignment.center,
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isActive ? backgroundPrimary : Colors.grey),
      child: Text(
        'Book',
        style: smallTextFont.copyWith(color: Colors.white),
      ),
    ),
  );
}

Widget dateTile(DateTime day, bool isSelected) {
  return Container(
    width: 60,
    height: 70,
    decoration: BoxDecoration(
        color: isSelected
            ? backgroundPrimary.withOpacity(0.7)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(7)),
    padding: EdgeInsets.all(8),
    margin: EdgeInsets.all(8),
    child: Column(
      children: [
        Text(getWeekday(day.weekday),
            style: smallTextFont.copyWith(
                color: isSelected ? Colors.white : Colors.black54,
                fontSize: 13)),
        smallSpace,
        Text(
          day.day.toString(),
          style: smallTextFont.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: isSelected ? Colors.white : Colors.black54),
        )
      ],
    ),
  );
}

Widget serviceTile(String title, double price, bool isSelected) {
  var color = isSelected ? backgroundSecondary : Colors.white24;
  var textColor = isSelected ? Colors.white : Colors.black87;

  return Container(
    margin: EdgeInsets.only(
      bottom: 12,
      left: 8,
      right: 8,
    ),
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isSelected
            ? backgroundPrimary.withOpacity(0.7)
            : Colors.black26.withOpacity(0.1)),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Ionicons.ios_checkmark_circle,
          color: color,
          size: 25,
        ),
        SizedBox(
          width: 15,
        ),
        Expanded(
            child: Container(
          margin: EdgeInsets.only(right: 15),
          child: Text(
            title,
            style: mediumTextFont.copyWith(
                fontSize: 14,
                letterSpacing: 1.25,
                fontWeight: FontWeight.w500,
                color: textColor),
          ),
        )),
        Text(
          'R ' + price.toString(),
          style: mediumTextFont.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.25,
              color: textColor),
        ),
        SizedBox(
          width: 15,
        )
      ],
    ),
  );
}

Widget slotTile(String time, bool isSelected, bool isAvailable) {
  Color backgroundColor =
      isSelected ? backgroundPrimary.withOpacity(0.7) : Colors.white38;
  Color textColor;

  if (isAvailable)
    textColor = isSelected ? Colors.white : Colors.black87;
  else
    textColor = Colors.black45;

  return Container(
    width: 80,
    height: 45,
    alignment: Alignment.center,
    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
    padding: EdgeInsets.all(13),
    color: backgroundColor,
    child: Text(
      time,
      style: smallTextFont.copyWith(
          fontWeight: FontWeight.w600, color: textColor, letterSpacing: 1.25),
    ),
  );
}
