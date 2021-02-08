class Booking {
  DateTime date;
  String bookingID;
  String clientID;
  String clientFCMToken;
  String slotID;
  String clientPhoneNumber;
  String employeeID;
  String clientName;
  String employeeName;
  bool walkIn;

  Booking(
      {this.date,
      this.walkIn = false,
      this.clientPhoneNumber = '',
      this.clientID = '',
      this.slotID = '',
      this.clientFCMToken = '',
      this.clientName = '',
      this.employeeID = '',
      this.employeeName = '',
      this.bookingID = ''}) {
    date = this.date ?? DateTime.now();
  }

  String timeToString() {
    int hour = date?.hour;
    int minute = date?.minute;

    var hourString = hour.toString().padLeft(2, '0');
    var minuteString = minute.toString().padLeft(2, '0');

    return hourString + ' : ' + minuteString;
  }

  Booking.fromMap(Map<String, dynamic> map, String uid) {
    bookingID = uid;
    clientID = map['clientID'];
    employeeID = map['employeeID'];
    slotID = map['slotID'];
    employeeName = map['employeeName'] ?? '';
    clientFCMToken = map['clientFCMToken'] ?? '';
    clientName = map['clientName'] ?? '';
    clientPhoneNumber = map['clientPhoneNumber'] ?? '';
    walkIn = map['walkIn'] ?? false;
    date = DateTime.tryParse(map['date']);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'date': date.toString(),
        'clientID': clientID,
        'employeeID': employeeID,
        'slotID': slotID ?? '',
        'clientFCMToken': clientFCMToken ?? '',
        'employeeName': employeeName ?? '',
        'clientName': clientName ?? '',
        'clientPhoneNumber': clientPhoneNumber ?? '',
        'walkIn': walkIn ?? false
      };
}

class LocalBooking {
  String storeID;
  String slotID;
  String employeeName;
  String storeName;
  String storeToken;
  DateTime date;

  LocalBooking(
      {this.storeName,
      this.slotID,
      this.storeID,
      this.employeeName,
      this.storeToken,
      String stringDate}) {
    date = DateTime.tryParse(stringDate);
    if (date == null) date = DateTime.now();
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'storeID': storeID,
        'storeName': storeName,
        'bookingDate': date.toString(),
        'slotID': slotID,
        'storeToken': storeToken,
        'employeeName': employeeName
      };

  LocalBooking.fromMap(Map<String, dynamic> map) {
    this.storeID = map['storeID'];
    this.slotID = map['slotID'];
    this.storeName = map['storeName'] ?? '';
    this.employeeName = map['employeeName'];
    this.storeToken = map['storeToken'] ?? '';
    this.date = DateTime.parse(map['bookingDate']);
  }

  String timeToString() {
    int hour = date?.hour;
    int minute = date?.minute;

    var hourString = hour.toString().padLeft(2, '0');
    var minuteString = minute.toString().padLeft(2, '0');

    return hourString + ' : ' + minuteString;
  }
}
