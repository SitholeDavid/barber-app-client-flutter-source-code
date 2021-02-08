class Service {
  String serviceID;
  double price;
  String title;
  String duration;
  List employees;

  Service(
      {this.serviceID = '',
      this.duration,
      this.employees,
      this.price,
      this.title});

  Service.fromMap(Map<String, dynamic> map, String uid) {
    serviceID = uid;
    price = map['price'];
    title = map['title'];
    duration = map['duration'];
    employees = List.from(map['employees']);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'price': price,
        'title': title,
        'duration': duration,
        'employees': employees ?? []
      };
}
