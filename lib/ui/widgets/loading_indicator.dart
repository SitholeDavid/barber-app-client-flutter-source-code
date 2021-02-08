import 'package:barber_app_client/ui/constants/ui_helpers.dart';
import 'package:barber_app_client/ui/shared/text_fonts.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

Widget loadingIndicator(bool isLoading, String loadingText) {
  return isLoading
      ? Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black54.withOpacity(0.8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  child: LoadingIndicator(
                      indicatorType: Indicator.circleStrokeSpin,
                      color: Colors.white),
                ),
                mediumSpace,
                mediumSpace,
                loadingText.isEmpty
                    ? emptySpace
                    : Text(
                        loadingText,
                        style: mediumTextFont.copyWith(
                            color: Colors.white, fontSize: 16),
                      )
              ],
            ),
          ),
        )
      : smallSpace;
}

Widget loadingIndicatorLight(bool isLoading, String loadingText) {
  return isLoading
      ? Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.transparent,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  child: LoadingIndicator(
                      indicatorType: Indicator.circleStrokeSpin,
                      color: Colors.black45),
                ),
                mediumSpace,
                mediumSpace,
                loadingText.isEmpty
                    ? emptySpace
                    : Text(
                        loadingText,
                        style: mediumTextFont.copyWith(
                            color: Colors.black54, fontSize: 16),
                      )
              ],
            ),
          ),
        )
      : smallSpace;
}
