abstract class LocalNotificationServiceInterface {
  Future initialise();
  Future selectNotification(String payload);
  Future scheduleNotification(String date, int id);
  Future cancelNotification(int id);
}
