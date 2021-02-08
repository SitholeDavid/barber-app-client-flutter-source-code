import 'package:barber_app_client/ui/constants/routes.dart';
import 'package:barber_app_client/ui/shared/text_fonts.dart';
import 'package:barber_app_client/ui/views/drawer_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../locator.dart';

class HeaderTileWidget extends StatelessWidget {
  final String heading;
  final NavigationService _navigationService = locator<NavigationService>();
  HeaderTileWidget({this.heading});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 50,
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () => _navigationService.navigateWithTransition(DrawerView(),
                transition: NavigationTransition.LeftToRighttWithFade),
            child: Icon(
              SimpleLineIcons.menu,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        SizedBox(
          width: 15,
        ),
        Text(
          heading,
          style: headerTextFont,
        )
      ],
    );
  }
}
