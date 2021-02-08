import 'package:barber_app_client/core/models/booking.dart';
import 'package:barber_app_client/core/models/notification.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_migration_service/sqflite_migration_service.dart';

import '../../../locator.dart';
import 'database_service_interface.dart';

class DatabaseService extends DatabaseServiceInterface {
  static const String DB_NAME = 'barbers_app_db.sqlite';
  static const String BookingsTable = 'bookings';
  static const String NotificationsTable = 'notifications';
  static const int DB_VERSION = 3;

  Database _database;

  final DatabaseMigrationService _migrationService =
      locator<DatabaseMigrationService>();

  Future initialise() async {
    _database = await openDatabase(DB_NAME, version: DB_VERSION);

    await _migrationService
        .runMigration(_database, migrationFiles: ['1_create_schema.sql']);
  }

  @override
  Future<bool> addBooking(LocalBooking booking) async {
    try {
      var jsonData = booking.toJson();
      await _database.insert(BookingsTable, jsonData);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future deleteBookings() async {
    await _database.delete(BookingsTable);
  }

  @override
  Future<bool> deleteBooking(String bookingID) async {
    try {
      await _database
          .delete(BookingsTable, where: 'slotID = ?', whereArgs: [bookingID]);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<LocalBooking>> getBookings() async {
    try {
      var result = await _database.query(BookingsTable);
      var bookings =
          result.map((booking) => LocalBooking.fromMap(booking)).toList();

      return bookings;
    } catch (e) {
      return <LocalBooking>[];
    }
  }

  @override
  Future<int> deleteNotification(String notificationDate) async {
    try {
      int id = await _database.delete(NotificationsTable,
          where: 'notificationDate = ?', whereArgs: [notificationDate]);
      return id;
    } catch (e) {
      return -1;
    }
  }

  @override
  Future<Notification> getNotification(String notificationDate) async {
    try {
      var jsonData = await _database.query(NotificationsTable,
          where: 'notificationDate = ?', whereArgs: [notificationDate]);

      return Notification.fromMap(jsonData.first);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<int> scheduleNotification(String notificationDate) async {
    try {
      int id = await _database
          .insert(NotificationsTable, {'notificationDate': notificationDate});
      return id;
    } catch (e) {
      return -1;
    }
  }
}
