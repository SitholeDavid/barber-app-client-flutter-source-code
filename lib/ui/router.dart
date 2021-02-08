import 'package:barber_app_client/core/models/employee.dart';
import 'package:barber_app_client/ui/constants/routes.dart';
import 'package:barber_app_client/ui/views/booking_view.dart';
import 'package:barber_app_client/ui/views/drawer_view.dart';
import 'package:barber_app_client/ui/views/find_shops_view.dart';
import 'package:barber_app_client/ui/views/login_view.dart';
import 'package:barber_app_client/ui/views/my_bookings_view.dart';
import 'package:barber_app_client/ui/views/my_profile_view.dart';
import 'package:barber_app_client/ui/views/payment_view.dart';
import 'package:barber_app_client/ui/views/shop_details_view.dart';
import 'package:barber_app_client/ui/views/signup_view.dart';
import 'package:barber_app_client/ui/views/startup_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case StartupViewRoute:
      return MaterialPageRoute(builder: (_) => StartupView());
    case LoginViewRoute:
      return MaterialPageRoute(builder: (_) => LoginView());
    case SignUpViewRoute:
      return MaterialPageRoute(builder: (_) => SignUpView());
    case FindShopViewRoute:
      return MaterialPageRoute(builder: (_) => FindShopsView());
    case ShopDetailsViewRoute:
      String storeID = settings.arguments as String;
      return MaterialPageRoute(
          builder: (_) => ShopDetailsView(storeID: storeID));
    case PaymentViewRoute:
      double cost = settings.arguments as double;
      return MaterialPageRoute(
          builder: (_) => PaymentView(
                cost: cost,
              ));

    case BookingViewRoute:
      ActiveEmployee employee = settings.arguments as ActiveEmployee;
      return MaterialPageRoute(builder: (_) => BookingView(employee: employee));

    case DrawerViewRoute:
      return MaterialPageRoute(builder: (_) => DrawerView());

    case MyProfileViewRoute:
      return MaterialPageRoute(builder: (_) => MyProfileView());
    case MyBookingsViewRoute:
      return MaterialPageRoute(builder: (_) => MyBookingsView());
  }
}
