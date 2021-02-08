import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'cloud_messaging_service_interface.dart';

class CloudMessagingService extends CloudMessagingServiceInterface {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  HttpsCallable cancelBooking =
      CloudFunctions.instance.getHttpsCallable(functionName: 'cancelMyBooking');

  HttpsCallable newBooking =
      CloudFunctions.instance.getHttpsCallable(functionName: 'newBooking');

  @override
  Future<String> getFCMToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      return '';
    }
  }

  @override
  Future storeCancelBookingNotification(
      {String storeToken, String name, String day, String time}) async {
    try {
      await cancelBooking.call(<String, dynamic>{
        'storeToken': storeToken,
        'name': name,
        'day': day,
        'time': time
      });
    } catch (e) {}
  }

  @override
  Future storeNewBookingNotification(
      {String storeToken, String name, String day, String time}) async {
    try {
      await newBooking.call(<String, dynamic>{
        'storeToken': storeToken,
        'name': name,
        'day': day,
        'time': time
      });
    } catch (e) {}
  }
}
