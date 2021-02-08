import 'package:barber_app_client/core/services/auth_service/auth_service.dart';
import 'package:barber_app_client/core/services/auth_service/auth_service_interface.dart';
import 'package:barber_app_client/ui/constants/routes.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../locator.dart';

class DrawerViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthServiceInterface>();

  void navigateToMyProfile() =>
      _navigationService.replaceWith(MyProfileViewRoute);

  void navigateToMyBookingsView() =>
      _navigationService.replaceWith(MyBookingsViewRoute);

  void logout() async {
    await _authService.signOut();
    _navigationService.replaceWith(LoginViewRoute);
  }
}
