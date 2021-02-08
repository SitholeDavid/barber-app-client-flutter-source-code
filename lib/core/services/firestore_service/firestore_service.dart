import 'package:barber_app_client/core/models/booking.dart';
import 'package:barber_app_client/core/models/client.dart';
import 'package:barber_app_client/core/models/employee.dart';
import 'package:barber_app_client/core/models/service.dart';
import 'package:barber_app_client/core/models/store.dart';
import 'package:barber_app_client/core/models/working_day.dart';
import 'package:barber_app_client/core/services/firestore_service/firestore_service_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService extends FirestoreServiceInterface {
  CollectionReference _storesRef = Firestore.instance.collection('stores');
  CollectionReference _servicesRef = Firestore.instance.collection('services');
  CollectionReference _clientsRef = Firestore.instance.collection('clients');
  CollectionReference _bookingsRef = Firestore.instance.collection('bookings');
  CollectionReference _workingHoursRef =
      Firestore.instance.collection('working-hours');
  CollectionReference _employeesRef =
      Firestore.instance.collection('employees');

  @override
  Future<Store> getStore(String storeID) async {
    try {
      var jsonData = await _storesRef.document(storeID).get();
      var store = Store.fromMap(jsonData.data, jsonData.documentID);
      return store;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ActiveEmployee>> getEmployees(String storeID) async {
    try {
      var employeesData = await _employeesRef
          .document(storeID)
          .collection('employees')
          .getDocuments();

      var employees = employeesData.documents
          .map((employee) =>
              ActiveEmployee.fromMap(employee.data, employee.documentID))
          .toList();

      return employees;
    } catch (e) {
      print('Error: ' + e.toString());
      return <ActiveEmployee>[];
    }
  }

  @override
  Future<List<Service>> getServices(String storeID) async {
    try {
      var servicesData = await _servicesRef
          .document(storeID)
          .collection('my-services')
          .getDocuments();

      return servicesData.documents
          .map((service) => Service.fromMap(service.data, service.documentID))
          .toList();
    } catch (e) {
      print('ERROR: ' + e.toString());
      return <Service>[];
    }
  }

  @override
  Future<List<WorkingDay>> getWorkingDays(String storeID) async {
    try {
      var workingDaysJson = await _workingHoursRef.document(storeID).get();
      var workingDays = workingDaysJson.data['days'] as List;
      if (workingDays == null) return <WorkingDay>[];

      return workingDays
          .map((day) => WorkingDay.fromString(day as String))
          .toList();
    } catch (e) {
      print('ERROR: ' + e.toString());
      return <WorkingDay>[];
    }
  }

  @override
  Future<bool> createClient(Client client, String clientID) async {
    try {
      await _clientsRef.document(clientID).setData(client.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Client> getClient(String clientID) async {
    try {
      var clientData = await _clientsRef.document(clientID).get();
      return Client.fromMap(clientData.data, clientID);
    } catch (e) {
      print('ERROR: ' + e.toString());
      return null;
    }
  }

  @override
  Future<bool> updateClient(Client client) async {
    try {
      await _clientsRef.document(client.clientID).updateData(client.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<Store>> getStores() async {
    try {
      var storesData = await _storesRef.getDocuments();
      return storesData.documents
          .map((store) => Store.fromMap(store.data, store.documentID))
          .toList();
    } catch (e) {
      return <Store>[];
    }
  }

  @override
  Future<List<Booking>> getBookings(
      String storeID, String employeeID, String date) async {
    try {
      var bookingsData = await _bookingsRef
          .document(storeID)
          .collection(date)
          .where('employeeID', isEqualTo: employeeID)
          .getDocuments();

      if (bookingsData.documents.isEmpty) return <Booking>[];

      return bookingsData.documents
          .map((booking) => Booking.fromMap(booking.data, booking.documentID))
          .toList();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> cancelBooking(String storeID, String date, String slotID) async {
    try {
      var bookingRefs = await _bookingsRef
          .document(storeID)
          .collection(date)
          .where('slotID', isEqualTo: slotID)
          .getDocuments();

      for (DocumentSnapshot snapshot in bookingRefs.documents)
        await snapshot.reference.delete();

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> createBooking(String storeID, List<Booking> slots) async {
    try {
      String date = slots[0].date.toString().split(' ').first;

      for (Booking booking in slots) {
        await _bookingsRef
            .document(storeID)
            .collection(date)
            .add(booking.toJson());
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<Service>> getEmployeeServices(
      String storeID, String employeeID) async {
    try {
      var servicesData = await _servicesRef
          .document(storeID)
          .collection('my-services')
          .where('employees', arrayContainsAny: [employeeID]).getDocuments();

      if (servicesData.documents.isEmpty) return <Service>[];

      return servicesData.documents
          .map((service) => Service.fromMap(service.data, service.documentID))
          .toList();
    } catch (e) {
      return <Service>[];
    }
  }
}
