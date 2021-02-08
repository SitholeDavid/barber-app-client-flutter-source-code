import 'package:barber_app_client/core/models/booking.dart';
import 'package:barber_app_client/core/models/employee.dart';
import 'package:barber_app_client/core/services/firestore_service/firestore_service.dart';
import 'package:barber_app_client/core/services/firestore_service/firestore_service_interface.dart';
import 'package:barber_app_client/core/utils.dart';
import 'package:barber_app_client/locator.dart';
import 'package:barber_app_client/ui/constants/routes.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ShopDetailsViewModel extends BaseViewModel {
  final FirestoreService _firestoreService =
      locator<FirestoreServiceInterface>();
  final NavigationService _navigationService = locator<NavigationService>();

  List<ActiveEmployee> employees;
  List<ActiveEmployee> filteredEmployees;
  String storeID;

  Future initialise(String storeID) async {
    setBusy(true);
    this.storeID = storeID;
    employees = await _firestoreService.getEmployees(storeID);
    await getBookingSlots();
    filteredEmployees = employees;

    notifyListeners();
    setBusy(false);
  }

  void navigateToBookingView(int employeeIndex) =>
      _navigationService.navigateTo(BookingViewRoute,
          arguments: filteredEmployees[employeeIndex]);

  Future getBookingSlots() async {
    String date = DateTime.now().toString().split(' ').first;
    var allSlots = <Booking>[];

    employees.forEach((employee) => employee.workingToday =
        validTimeForEmployee(
            employee.workingDays, DateTime.now(), Duration(days: 0)));

    for (ActiveEmployee employee in employees) {
      var employeeSlots = await _firestoreService.getBookings(
          storeID, employee.employeeID, date);

      employee.noWaiting = employeeSlots.length;
      employee.slots = employeeSlots;
      employee.storeID = storeID;
      allSlots.addAll(employeeSlots);
    }

    return allSlots;
  }
}
