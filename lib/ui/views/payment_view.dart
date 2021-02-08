import 'package:barber_app_client/core/viewmodels/payment_viewmodel.dart';
import 'package:barber_app_client/ui/constants/margins.dart';
import 'package:barber_app_client/ui/shared/colors.dart';
import 'package:barber_app_client/ui/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class PaymentView extends StatelessWidget {
  final double cost;
  PaymentView({this.cost});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PaymentViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
              backgroundColor: backgroundSecondary,
              body: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: pageHorizontalMargin,
                    vertical: pageVerticalMargin),
                child: Center(
                    child: loadingIndicatorLight(true, model.loadingText)),
              ),
            ),
        onModelReady: (model) => model.initialise(cost, context),
        viewModelBuilder: () => PaymentViewModel());
  }
}
