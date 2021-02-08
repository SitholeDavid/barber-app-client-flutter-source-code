import 'package:barber_app_client/core/models/booking.dart';
import 'package:barber_app_client/core/services/auth_service/auth_service.dart';
import 'package:barber_app_client/core/services/auth_service/auth_service_interface.dart';
import 'package:barber_app_client/core/services/cloud_messaging_service/cloud_messaging_service.dart';
import 'package:barber_app_client/core/services/cloud_messaging_service/cloud_messaging_service_interface.dart';
import 'package:barber_app_client/core/services/database_service/database_service.dart';
import 'package:barber_app_client/core/services/database_service/database_service_interface.dart';
import 'package:barber_app_client/core/services/firestore_service/firestore_service.dart';
import 'package:barber_app_client/core/services/firestore_service/firestore_service_interface.dart';
import 'package:barber_app_client/core/services/local_notifications_service/local_notification_service.dart';
import 'package:barber_app_client/core/services/local_notifications_service/local_notification_service_interface.dart';
import 'package:barber_app_client/locator.dart';
import 'package:barber_app_client/ui/constants/enums.dart';
import 'package:barber_app_client/ui/constants/routes.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../utils.dart';

class MyBookingsViewModel extends BaseViewModel {
  final DatabaseService _databaseService = locator<DatabaseServiceInterface>();
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService =
      locator<FirestoreServiceInterface>();
  final LocalNotificationService _notificationService =
      locator<LocalNotificationServiceInterface>();
  final CloudMessagingService _messagingService =
      locator<CloudMessagingServiceInterface>();
  final AuthService _authService = locator<AuthServiceInterface>();

  List<LocalBooking> myBookings;
  String loadingText = 'Loading bookings';

  void initialise() async {
    setBusy(true);

    myBookings = await _databaseService.getBookings();

    setBusy(false);
  }

  void sendCancelBookingNotification(LocalBooking booking) async {
    String name = (await _authService.getCurrentUser()).name;
    String day = formatDay(booking.date.toString());
    String time = formatTime(booking.date);

    _messagingService.storeCancelBookingNotification(
        name: name, day: day, time: time, storeToken: booking.storeToken);
  }

  void onBookingSelected(int index) async {
    var booking = myBookings[index];
    if (booking.date.isBefore(DateTime.now())) return;

    var response = await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.cancelBooking);

    if (response.confirmed) {
      loadingText = 'Cancelling booking..';
      setBusy(true);

      bool deletedInCloud = await _firestoreService.cancelBooking(
          booking.storeID,
          booking.date.toString().split(' ').first,
          booking.slotID);

      if (!deletedInCloud)
        return showSuccessSnackbar(false);
      else
        sendCancelBookingNotification(booking);

      await _databaseService.deleteBooking(booking.slotID);
      await cancelBookingNotifications(booking.date);

      showSuccessSnackbar(true);
      Future.delayed(Duration(seconds: 2),
          () => _navigationService.clearStackAndShow(FindShopViewRoute));
      setBusy(false);
    }
  }

  Future<bool> cancelBookingNotifications(DateTime date) async {
    String dayBefore = date.subtract(Duration(days: 1)).toString();
    String hourBefore = date.subtract(Duration(hours: 1)).toString();

    int dayBeforeID = (await _databaseService.deleteNotification(dayBefore));
    int hourBeforeID = (await _databaseService.deleteNotification(hourBefore));

    if (dayBeforeID == -1 || hourBeforeID == -1) return false;

    await _notificationService.cancelNotification(dayBeforeID);
    await _notificationService.cancelNotification(hourBeforeID);

    return true;
  }

  void showSuccessSnackbar(bool success) {
    _snackbarService.showSnackbar(
        message: success
            ? 'Your booking was successfully cancelled'
            : 'An error occured, please try again later',
        duration: Duration(seconds: 2));
  }
}
