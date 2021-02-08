import 'package:barber_app_client/core/viewmodels/drawer_viewmodel.dart';
import 'package:barber_app_client/ui/constants/ui_helpers.dart';
import 'package:barber_app_client/ui/shared/colors.dart';
import 'package:barber_app_client/ui/shared/text_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:stacked/stacked.dart';

class DrawerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DrawerViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
              backgroundColor: backgroundPrimary,
              body: Container(
                width: double.infinity,
                height: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15),
                margin: EdgeInsets.only(right: 130),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    extraLargeSpace,
                    Text(
                      'BARBERS SA',
                      style: headerTextFont.copyWith(
                          fontSize: 24,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w800,
                          color: backgroundPrimary),
                    ),
                    extraLargeSpace,
                    TextButton(
                        onPressed: model.navigateToMyProfile,
                        child: ListTile(
                          leading: Icon(FontAwesome.group),
                          title: Text(
                            'My profile',
                            style: smallTextFont.copyWith(fontSize: 18),
                          ),
                        )),
                    mediumSpace,
                    TextButton(
                        onPressed: model.navigateToMyBookingsView,
                        child: ListTile(
                          leading: Icon(MaterialIcons.schedule),
                          title: Text(
                            'My Bookings',
                            style: smallTextFont.copyWith(fontSize: 18),
                          ),
                        )),
                    mediumSpace,
                    TextButton(
                        onPressed: model.logout,
                        child: ListTile(
                          leading: Icon(Octicons.settings),
                          title: Text(
                            'Logout',
                            style: smallTextFont.copyWith(fontSize: 18),
                          ),
                        ))
                  ],
                ),
              ),
            ),
        viewModelBuilder: () => DrawerViewModel());
  }
}
