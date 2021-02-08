import 'package:barber_app_client/core/services/local_notifications_service/local_notification_service_interface.dart';
import 'package:barber_app_client/locator.dart';
import 'package:barber_app_client/ui/constants/routes.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService extends LocalNotificationServiceInterface {
  final NavigationService _navigationService = locator<NavigationService>();
  FlutterLocalNotificationsPlugin _notificationsPlugin;
  AndroidNotificationDetails _androidPlatformChannelSpecifics;

  @override
  Future initialise() async {
    _notificationsPlugin = FlutterLocalNotificationsPlugin();

    _androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.max, priority: Priority.high, showWhen: false);

    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final IOSInitializationSettings iosInit = IOSInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(android: androidInit, iOS: iosInit);

    await _notificationsPlugin.initialize(initializationSettings);
  }

  @override
  Future selectNotification(String payload) async {
    _navigationService.navigateTo(FindShopViewRoute);
  }

  @override
  Future cancelNotification(int id) async {
    try {
      await _notificationsPlugin.cancel(id);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future scheduleNotification(String date, int id) async {
    try {
      tz.initializeTimeZones();
      String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(currentTimeZone));

      String displayTime = date.split(' ').last.substring(0, 5);
      tz.TZDateTime sessionDate = tz.TZDateTime.parse(tz.local, date);
      tz.TZDateTime notificationDate = sessionDate.subtract(Duration(
          minutes: 1)); //Notification scheduled for 24 hours before booking

      await _notificationsPlugin.zonedSchedule(
          id,
          'Booking reminder',
          'Don\'t forget your booking tomorrow at $displayTime!',
          notificationDate,
          NotificationDetails(android: _androidPlatformChannelSpecifics),
          uiLocalNotificationDateInterpretation: null,
          androidAllowWhileIdle: true);

      return true;
    } catch (e) {
      return e;
    }
  }
}
