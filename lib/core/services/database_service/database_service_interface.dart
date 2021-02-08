import 'package:barber_app_client/core/models/booking.dart';
import 'package:barber_app_client/core/models/notification.dart';

abstract class DatabaseServiceInterface {
  Future<List<LocalBooking>> getBookings();
  Future<bool> addBooking(LocalBooking booking);
  Future<bool> deleteBooking(String bookingID);

  Future<int> scheduleNotification(String notificationDate);
  Future<Notification> getNotification(String notificationDate);
  Future<int> deleteNotification(String notificationDate);
}
