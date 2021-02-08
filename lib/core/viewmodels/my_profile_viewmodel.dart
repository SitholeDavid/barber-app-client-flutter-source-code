import 'package:barber_app_client/core/models/client.dart';
import 'package:barber_app_client/core/services/auth_service/auth_service.dart';
import 'package:barber_app_client/core/services/auth_service/auth_service_interface.dart';
import 'package:barber_app_client/core/services/firestore_service/firestore_service.dart';
import 'package:barber_app_client/core/services/firestore_service/firestore_service_interface.dart';
import 'package:barber_app_client/locator.dart';
import 'package:barber_app_client/ui/constants/routes.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class MyProfileViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final AuthService _authService = locator<AuthServiceInterface>();
  final FirestoreService _firestoreService =
      locator<FirestoreServiceInterface>();

  Client user;

  Future initialise() async {
    setBusy(true);
    user = await _authService.getCurrentUser();
    setInitialised(true);
    setBusy(false);
  }

  Future updateProfile({String name, String surname, String phoneNo}) async {
    setBusy(true);

    user.name = name;
    user.surname = surname;
    user.phoneNo = phoneNo;

    bool success = await _firestoreService.updateClient(user);

    if (success) {
      _snackbarService.showSnackbar(
          message: 'Your profile has been updated',
          duration: Duration(seconds: 2));

      Future.delayed(Duration(seconds: 2),
          () => _navigationService.navigateTo(FindShopViewRoute));
    } else {
      _snackbarService.showSnackbar(
          message:
              'Profile update failed, please check your details and try again',
          duration: Duration(seconds: 2));
    }

    setBusy(false);
  }
}
