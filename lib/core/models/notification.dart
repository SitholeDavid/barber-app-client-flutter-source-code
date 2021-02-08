class Notification {
  String date;
  int notificationID;

  Notification({this.date, this.notificationID});

  Notification.fromMap(Map<String, dynamic> map) {
    date = map['date'];
    notificationID = map['id'];
  }
}
