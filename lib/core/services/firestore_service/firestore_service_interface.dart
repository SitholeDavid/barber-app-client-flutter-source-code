import 'package:barber_app_client/core/models/booking.dart';
import 'package:barber_app_client/core/models/client.dart';
import 'package:barber_app_client/core/models/employee.dart';
import 'package:barber_app_client/core/models/service.dart';
import 'package:barber_app_client/core/models/store.dart';
import 'package:barber_app_client/core/models/working_day.dart';

abstract class FirestoreServiceInterface {
  Future<bool> createClient(Client client, String clientID);
  Future<Client> getClient(String clientID);
  Future<bool> updateClient(Client client);

  Future<Store> getStore(String storeID);
  Future<List<Store>> getStores();

  Future<List<ActiveEmployee>> getEmployees(String storeID);
  Future<List<Service>> getEmployeeServices(String storeID, String employeeID);

  Future<List<Service>> getServices(String storeID);

  Future<List<WorkingDay>> getWorkingDays(String storeID);

  Future<List<Booking>> getBookings(
      String storeID, String employeeID, String date);
  Future<bool> createBooking(String storeID, List<Booking> slots);
  Future<bool> cancelBooking(String storeID, String date, String slotID);
}
