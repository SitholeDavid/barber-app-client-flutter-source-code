import 'package:barber_app_client/ui/constants/enums.dart';
import 'package:barber_app_client/ui/constants/ui_helpers.dart';
import 'package:barber_app_client/ui/shared/text_fonts.dart';
import 'package:barber_app_client/ui/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../locator.dart';

void setupBottomSheetUi() {
  final bottomSheetService = locator<BottomSheetService>();

  final builders = {
    BottomSheetType.confirmBooking: (context, sheetRequest, completer) =>
        _ConfirmBookingBottomSheet(request: sheetRequest, completer: completer),
    BottomSheetType.cancelBooking: (context, sheetRequest, completer) =>
        _ConfirmCancellationBottomSheet(
            request: sheetRequest, completer: completer)
  };

  bottomSheetService.setCustomSheetBuilders(builders);
}

class _ConfirmCancellationBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;
  const _ConfirmCancellationBottomSheet({
    Key key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Cancel booking',
            style: largeTextFont,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Are you sure you want to cancel this booking? Booking fees are used to compensate the store in the case that a cancellation leads to lost income. For this reason booking fees are non-refundable.',
              style: smallTextFont.copyWith(letterSpacing: 1.15, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ),
          mediumSpace,
          customButtonDarkLarge('Cancel booking',
              () => completer(SheetResponse(confirmed: true)), true)
        ],
      ),
    );
  }
}

class _ConfirmBookingBottomSheet extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;
  const _ConfirmBookingBottomSheet({
    Key key,
    this.request,
    this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Confirm booking',
            style: largeTextFont,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              'A deposit booking fee of R ${request.customData} is payable to secure your slot. The remainder amount of R ${request.title} will be paid in store.',
              style: smallTextFont.copyWith(letterSpacing: 1.15, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ),
          mediumSpace,
          customButtonDarkLarge('Confirm booking',
              () => completer(SheetResponse(confirmed: true)), true)
        ],
      ),
    );
  }
}
