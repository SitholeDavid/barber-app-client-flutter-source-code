abstract class CloudMessagingServiceInterface {
  Future<String> getFCMToken();

  Future storeNewBookingNotification(
      {String storeToken, String name, String day, String time});
  Future storeCancelBookingNotification(
      {String storeToken, String name, String day, String time});
}
