class Store {
  String storeID;
  String storeFCMToken;
  String email;
  String name;
  String address;
  String description;
  int noEmployees;
  int daysInAdvance;
  int bookingPercentage;

  Store(
      {this.storeID,
      this.email,
      this.name,
      this.address,
      this.description,
      this.storeFCMToken,
      this.daysInAdvance,
      this.bookingPercentage,
      this.noEmployees});

  Store.fromMap(Map<String, dynamic> map, String uid) {
    storeID = uid;
    email = map['email'];
    name = map['name'];
    address = map['address'];
    description = map['description'];
    noEmployees = map['noEmployees'];
    storeFCMToken = map['storeFCMToken'];
    bookingPercentage = map['bookingPercentage'] ?? 0;
    daysInAdvance = map['daysInAdvance'] ?? 0;
  }

  Map<String, dynamic> toJson() => {
        'name': name ?? '',
        'email': email ?? '',
        'address': address ?? '',
        'description': description ?? '',
        'noEmployees': noEmployees ?? 0,
        'storeFCMToken': storeFCMToken ?? '',
        'bookingPercentage': bookingPercentage ?? 0,
        'daysInAdvance': daysInAdvance ?? 0
      };
}
