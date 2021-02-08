import 'package:barber_app_client/core/models/booking.dart';
import 'package:barber_app_client/core/models/working_day.dart';

import '../utils.dart';

class Employee {
  String employeeID;
  String name;
  String surname;
  String role;
  String displayPictureUrl;
  List<WorkingDay> workingDays;

  Employee(
      {this.name = '',
      this.surname = '',
      this.role = '',
      this.workingDays,
      this.displayPictureUrl = ''});

  Employee.fromMap(Map<String, dynamic> map, String uid) {
    employeeID = uid;
    name = map['name'];
    surname = map['surname'];
    role = map['role'];
    displayPictureUrl = map['displayPictureUrl'];

    workingDays = <WorkingDay>[];

    for (String day in map['workingDays'])
      workingDays.add(WorkingDay.fromString(day));
  }

  WorkingDay getWorkingDay(int key) {
    String weekday = getWeekday(key).toUpperCase();

    for (WorkingDay day in workingDays) {
      print('OG: ' + weekday);
      print('TEST: ' + day.title.toUpperCase());
      if (day.title.toUpperCase() == weekday) return day;
    }

    return null;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'surname': surname,
        'role': role,
        'displayPictureUrl': displayPictureUrl ?? '',
        'workingDays': workingDays.map((day) => day.toString()).toList()
      };
}

class ActiveEmployee extends Employee {
  int noWaiting;
  String storeID;
  bool workingToday;
  List<Booking> slots;

  ActiveEmployee.fromMap(Map<String, dynamic> map, String uid)
      : super.fromMap(map, uid);

  Map<String, dynamic> toJson() => super.toJson();
}
