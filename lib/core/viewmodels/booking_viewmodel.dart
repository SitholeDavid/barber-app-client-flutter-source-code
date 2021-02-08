import 'package:barber_app_client/core/models/booking.dart';
import 'package:barber_app_client/core/models/booking_data.dart';
import 'package:barber_app_client/core/models/client.dart';
import 'package:barber_app_client/core/models/employee.dart';
import 'package:barber_app_client/core/models/notification.dart';
import 'package:barber_app_client/core/models/service.dart';
import 'package:barber_app_client/core/models/store.dart';
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
import 'package:barber_app_client/core/utils.dart';
import 'package:barber_app_client/locator.dart';
import 'package:barber_app_client/ui/constants/enums.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uuid/uuid.dart';

class BookingViewModel extends BaseViewModel {
  final FirestoreService _firestoreService =
      locator<FirestoreServiceInterface>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final AuthService _authService = locator<AuthServiceInterface>();
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DatabaseService _databaseService = locator<DatabaseServiceInterface>();
  final LocalNotificationService _notificationService =
      locator<LocalNotificationServiceInterface>();
  final DialogService _dialogService = locator<DialogService>();
  final CloudMessagingService _messagingService =
      locator<CloudMessagingServiceInterface>();

  ActiveEmployee selectedEmployee;
  List<Service> availableServices;
  List<Booking> bookingSlots = <Booking>[];
  List<bool> selectedServices;
  List<DateTime> bookingDays;
  List<Booking> myBookings = <Booking>[];
  DateTime selectedDay;
  Client client;
  int bookingPercentage;
  Store store;
  String loadingText = 'Fetching booking slots..';

  int currentStep = 0;
  bool canGoToNextStep = false;

  Future initialise(ActiveEmployee employee) async {
    setBusy(true);

    selectedEmployee = employee;

    client = await _authService.getCurrentUser();

    store = await _firestoreService.getStore(selectedEmployee.storeID);

    int daysInAdvance = store.daysInAdvance;
    bookingPercentage = store.bookingPercentage;

    bookingDays = generateBookingDays(daysInAdvance);

    availableServices = await _firestoreService.getEmployeeServices(
        selectedEmployee.storeID, selectedEmployee.employeeID);

    selectedServices = List<bool>.filled(availableServices.length, false);

    setBusy(false);
  }

  void nextStep() {
    currentStep++;
    canGoToNextStep = false;
    notifyListeners();
  }

  void prevStep() {
    currentStep > 0 ? currentStep-- : currentStep = 0;
    canGoToNextStep = true;
    notifyListeners();
  }

  void updateSelectedServices(int index) {
    selectedServices[index] = !selectedServices[index];
    canGoToNextStep = selectedServices.any((element) => element == true);
    notifyListeners();
  }

  void onBookingDaySelected(int index) async {
    var day = bookingDays[index];
    selectedDay = day;
    String date = day.toString().split(' ').first;
    var bookedSlots = await _firestoreService.getBookings(
        selectedEmployee.storeID, selectedEmployee.employeeID, date);

    var employeeDay = selectedEmployee.getWorkingDay(day.weekday);

    if (employeeDay.working) {
      var openSlots = generateBookingSlots(selectedDay,
          employeeDay.startTime.toString(), employeeDay.endTime.toString());

      for (Booking booked in bookedSlots) {
        for (Booking open in openSlots) {
          if (booked.date.hour == open.date.hour &&
              booked.date.minute == open.date.minute) {
            int position = openSlots.indexWhere((slot) => slot == open);
            openSlots.removeAt(position);
            openSlots.insert(position, booked);
          }
        }
      }

      bookingSlots = openSlots;
    } else {
      bookingSlots = <Booking>[];
    }

    canGoToNextStep = false;
    myBookings.clear();
    notifyListeners();
  }

  void book() async {
    if (myBookings.isEmpty) return;

    double fee = computeFee(availableServices, selectedServices);
    double bookingFee = (fee * bookingPercentage / 100);

    /*

    var response = await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.confirmBooking,
        title: (fee - bookingFee).toString(),
        customData: bookingFee);

    bool paymentSuccessful;

    if (response.confirmed) {
      paymentSuccessful = await _navigationService.navigateTo(PaymentViewRoute,
          arguments: bookingFee);
    } else
      return;
    loadingText = 'Processing payment..';
    setBusy(true);

    if (!paymentSuccessful) {
      setBusy(false);
      return showSuccessSnackbar(false);
    }

    */

    loadingText = 'Completing booking..';
    notifyListeners();

    String slotID = Uuid().v1();
    String myToken = await _messagingService.getFCMToken();

    for (int index = 0; index < myBookings.length; index++) {
      myBookings[index].clientFCMToken = myToken;
      myBookings[index].slotID = slotID;
      myBookings[index].clientName = client.name;
      myBookings[index].clientPhoneNumber = client.phoneNo;
      myBookings[index].employeeName =
          selectedEmployee.name + ' ' + selectedEmployee.surname;
      myBookings[index].employeeID = selectedEmployee.employeeID;
      myBookings[index].walkIn = false;
    }

    bool success = await _firestoreService.createBooking(
        selectedEmployee.storeID, myBookings);

    if (!success) return showSuccessSnackbar(false);

    await saveBookingLocally(myBookings.first);
    await scheduleNotificationsForBooking(myBookings.first);
    await showBookingSuccessfulDialog();
    _navigationService.back();
  }

  void sendNewBookingNotification() {
    String day = formatDay(myBookings.first.date.toString());
    String time = formatTime(myBookings.first.date);

    _messagingService.storeNewBookingNotification(
        name: client.name,
        day: day,
        time: time,
        storeToken: store.storeFCMToken);
  }

  void sendCancelBookingNotification() {
    String day = formatDay(selectedDay.toString());
    String time = formatTime(selectedDay);

    _messagingService.storeCancelBookingNotification(
        name: client.name,
        day: day,
        time: time,
        storeToken: store.storeFCMToken);
  }

  Future showBookingSuccessfulDialog() async {
    var employeeName = selectedEmployee.name + ' ' + selectedEmployee.surname;
    var date = formatDatetime(selectedDay);
    var time = myBookings.first.timeToString();

    var bookingData =
        BookingData(employeeName: employeeName, date: date, time: time);

    await _dialogService.showCustomDialog(
        variant: DialogType.bookingSuccessful, customData: bookingData);
  }

  void cancelBooking(String slotID) async {
    var response = await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.cancelBooking);

    if (!response.confirmed) return;

    loadingText = 'Cancelling booking..';
    setBusy(true);

    String date = selectedDay.toString().split(' ').first;
    bool success = await _firestoreService.cancelBooking(
        selectedEmployee.storeID, date, slotID);

    await deleteBookingLocally(slotID);
    await cancelBookingNotifications(selectedDay);
    showSuccessSnackbar(success);

    Future.delayed(Duration(seconds: 2), () => _navigationService.back());
    setBusy(false);
  }

  void showSuccessSnackbar(bool success) {
    _snackbarService.showSnackbar(
        message: success
            ? 'Your booking was successful'
            : 'Your booking was unsuccessful',
        duration: Duration(seconds: 2));
  }

  void onSlotSelected(int index) async {
    if (bookingSlots[index].slotID.isNotEmpty &&
        bookingSlots[index].bookingID == 'reserved') {
      String slotID = bookingSlots[index].slotID;
      bookingSlots.forEach((slot) {
        if (slot.slotID == slotID) {
          slot.slotID = '';
          slot.clientID = '';
          slot.bookingID = '';
        }
      });

      canGoToNextStep = false;
      myBookings.clear();
      return notifyListeners();
    }

    if (myBookings.isNotEmpty) return;

    var serviceDuration = computeDuration(availableServices, selectedServices);

    var referenceTime = bookingSlots[index].date;
    bool slotsOpen = validBooking(bookingSlots, referenceTime, serviceDuration);

    if (!slotsOpen)
      return _snackbarService.showSnackbar(
          message: 'Selected slot will clash with existing bookings.');

    var endTime = referenceTime.add(serviceDuration);
    myBookings = <Booking>[]; //To be sent to database
    String slotID = Uuid().v1();

    while (referenceTime.isBefore(endTime)) {
      int position =
          bookingSlots.indexWhere((slot) => slot.date == referenceTime);

      bookingSlots[position].bookingID = 'reserved';
      bookingSlots[position].clientID = client.clientID;
      bookingSlots[position].employeeID = selectedEmployee.employeeID;
      bookingSlots[position].date = referenceTime;
      bookingSlots[position].slotID = slotID;
      referenceTime = referenceTime.add(Duration(minutes: 15));

      myBookings.add(bookingSlots[position]);
    }

    canGoToNextStep = true;
    notifyListeners();
  }

  Future<bool> scheduleNotificationsForBooking(Booking booking) async {
    String dayBefore = booking.date.subtract(Duration(days: 1)).toString();
    String hourBefore = booking.date.subtract(Duration(hours: 1)).toString();

    int dayBeforeID = await _databaseService.scheduleNotification(dayBefore);
    int hourBeforeID = await _databaseService.scheduleNotification(hourBefore);

    if (dayBeforeID == -1 || hourBeforeID == -1) return false;

    bool dayBeforeScheduled =
        await _notificationService.scheduleNotification(dayBefore, dayBeforeID);
    bool hourBeforeScheduled = await _notificationService.scheduleNotification(
        hourBefore, hourBeforeID);

    if (!dayBeforeScheduled || !hourBeforeScheduled) return false;

    sendNewBookingNotification();
    return true;
  }

  Future<bool> cancelBookingNotifications(DateTime date) async {
    String dayBefore = date.subtract(Duration(days: 1)).toString();
    String hourBefore = date.subtract(Duration(hours: 1)).toString();

    int dayBeforeID = (await _databaseService.deleteNotification(dayBefore));
    int hourBeforeID = (await _databaseService.deleteNotification(hourBefore));

    if (dayBeforeID == -1 || hourBeforeID == -1) return false;

    await _notificationService.cancelNotification(dayBeforeID);
    await _notificationService.cancelNotification(hourBeforeID);
    sendCancelBookingNotification();
    return true;
  }

  Future<bool> deleteBookingLocally(String id) async =>
      await _databaseService.deleteBooking(id);

  Future<bool> saveBookingLocally(Booking booking) async {
    LocalBooking localBooking = LocalBooking(
        storeID: store.storeID,
        storeName: store.name,
        employeeName: selectedEmployee.name,
        slotID: booking.slotID,
        stringDate: booking.date.toString());

    return await _databaseService.addBooking(localBooking);
  }
}
