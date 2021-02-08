import 'package:barber_app_client/core/services/auth_service/auth_service.dart';
import 'package:barber_app_client/core/services/auth_service/auth_service_interface.dart';
import 'package:barber_app_client/locator.dart';
import 'package:barber_app_client/ui/constants/routes.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends BaseViewModel {
  String title = 'BARBERS SA';
  String loadingText = 'Logging in..';
  String description =
      'Helping you save time and avoid the hassle of waiting in long queues';

  final NavigationService _navigationService = locator<NavigationService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final AuthService _authService = locator<AuthServiceInterface>();

  void login({String email, String password}) async {
    setBusy(true);

    bool success = await _authService.signInWithEmail(email, password);

    if (success)
      _navigationService.navigateTo(FindShopViewRoute);
    else
      _snackbarService.showSnackbar(
          message: 'Login failed. Please check your email and/or password.',
          duration: Duration(seconds: 2));

    setBusy(false);
  }

  void navigateToSignUp() {
    _navigationService.navigateTo(SignUpViewRoute);
  }
}

class EmployeesViewRoute {}
