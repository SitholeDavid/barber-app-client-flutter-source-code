import 'package:barber_app_client/core/services/auth_service/auth_service.dart';
import 'package:barber_app_client/core/services/auth_service/auth_service_interface.dart';
import 'package:barber_app_client/core/services/database_service/database_service.dart';
import 'package:barber_app_client/core/services/database_service/database_service_interface.dart';
import 'package:barber_app_client/core/services/local_notifications_service/local_notification_service.dart';
import 'package:barber_app_client/core/services/local_notifications_service/local_notification_service_interface.dart';
import 'package:barber_app_client/locator.dart';
import 'package:barber_app_client/ui/constants/routes.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthServiceInterface>();
  final DatabaseService _databaseService = locator<DatabaseServiceInterface>();
  final LocalNotificationService _notificationService =
      locator<LocalNotificationServiceInterface>();

  void initialise() async {
    bool isLoggedIn = await _authService.isUserLoggedIn();
    await _databaseService
        .initialise(); //initialise database service in background
    await _notificationService.initialise();

    if (isLoggedIn) {
      _navigationService.clearStackAndShow(FindShopViewRoute);
    } else {
      _navigationService.clearStackAndShow(LoginViewRoute);
    }
  }
}
