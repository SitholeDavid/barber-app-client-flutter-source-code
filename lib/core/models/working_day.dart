import 'package:barber_app_client/core/utils.dart';

class WorkingDay {
  String title;
  DateTime startTime = DateTime(2020, 0, 0, 5, 30);
  DateTime endTime = DateTime(2020, 0, 0, 17, 0);
  DateTime duration = DateTime(2020, 0, 0, 0, 45);
  bool working;
  int key;

  WorkingDay(
      {this.title,
      this.startTime,
      this.endTime,
      this.duration,
      this.key,
      this.working}) {
    startTime = startTime ?? DateTime(2020, 0, 0, 5, 30);
    endTime = endTime ?? DateTime(2020, 0, 0, 17, 0);
    duration = duration ?? DateTime(2020, 0, 0, 0, 45);
  }

  WorkingDay.fromMap(Map<String, dynamic> map) {
    title = map['title'];
    startTime = DateTime.parse(map['startTime']);
    endTime = DateTime.parse(map['endTime']);
    duration = DateTime.parse(map['duration']);
    working = map['working'] as bool;
  }

  WorkingDay.fromString(String workingDay) {
    var props = workingDay.split(',');
    title = props[0];
    startTime = DateTime.tryParse(props[1]);
    endTime = DateTime.tryParse(props[2]);
    duration = DateTime.tryParse(props[3]);
    working = props[4] == 'true' ? true : false;
    key = getWeekdayKey(title);
  }

  @override
  String toString() {
    return '$title,${startTime.toString()},${endTime.toString()},${duration.toString()},${working.toString()}';
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map;

    map['title'] = title;
    map['startTime'] = startTime.toString();
    map['endTime'] = endTime.toString();
    map['duration'] = duration.toString();
    map['working'] = working;
    return map;
  }
}
