import 'package:barber_app_client/core/services/auth_service/auth_service.dart';
import 'package:barber_app_client/core/services/auth_service/auth_service_interface.dart';
import 'package:barber_app_client/locator.dart';
import 'package:barber_app_client/ui/constants/routes.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SignUpViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final AuthService _authService = locator<AuthServiceInterface>();

  Future signUp(
      {String email,
      String password,
      String name,
      String surname,
      String phoneNo}) async {
    setBusy(true);

    bool success = await _authService.signUpWithEmail(
        email, password, name, surname, phoneNo);

    if (success) {
      _snackbarService.showSnackbar(
          message: 'Sign up successful', duration: Duration(seconds: 2));

      Future.delayed(Duration(seconds: 2),
          () => _navigationService.navigateTo(FindShopViewRoute));
    } else {
      _snackbarService.showSnackbar(
          message: 'Sign up failed, please check your details and try again',
          duration: Duration(seconds: 2));
    }

    setBusy(false);
  }
}
