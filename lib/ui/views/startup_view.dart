import 'package:barber_app_client/core/viewmodels/startup_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class StartupView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartupViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Text('Startup'),
      ),
      viewModelBuilder: () => StartupViewModel(),
      onModelReady: (model) => model.initialise(),
    );
  }
}
