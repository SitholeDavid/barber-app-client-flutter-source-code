import 'package:barber_app_client/core/models/booking.dart';
import 'package:barber_app_client/core/models/service.dart';

import 'models/working_day.dart';

var defaultWorkingDays = <WorkingDay>[
  WorkingDay(title: 'Mon', working: false, key: 1),
  WorkingDay(title: 'Tue', working: false, key: 2),
  WorkingDay(title: 'Wed', working: false, key: 3),
  WorkingDay(title: 'Thu', working: false, key: 4),
  WorkingDay(title: 'Fri', working: false, key: 5),
  WorkingDay(title: 'Sat', working: false, key: 6),
  WorkingDay(title: 'Sun', working: false, key: 7),
];

String getWeekday(int weekday) {
  switch (weekday) {
    case 1:
      return 'Mon';
    case 2:
      return 'Tue';
    case 3:
      return 'Wed';
    case 4:
      return 'Thu';
    case 5:
      return 'Fri';
    case 6:
      return 'Sat';
    case 7:
      return 'Sun';
    default:
      return 'Sun';
  }
}

String formatDatetime(DateTime selectedDay) {
  var date = selectedDay.day.toString() +
      ' ' +
      getMonth(selectedDay.month) +
      ', ' +
      selectedDay.year.toString();

  return date;
}

int getWeekdayKey(String weekday) {
  switch (weekday) {
    case 'Mon':
      return 1;
    case 'Tue':
      return 2;
    case 'Wed':
      return 3;
    case 'Thu':
      return 4;
    case 'Fri':
      return 5;
    case 'Sat':
      return 6;
    case 'Sun':
      return 7;
    default:
      return 1;
  }
}

bool validTimeForEmployee(List<WorkingDay> workingHours, DateTime selectedTime,
    Duration serviceTime) {
  String day = getWeekday(selectedTime.weekday);
  WorkingDay workingDay = workingHours.firstWhere((val) => val.title == day);

  //check if employee is working on selected day
  if (!workingDay.working) return false;

  //check if selected time is not before employee's shift

  if (timeComesBefore(selectedTime, workingDay.startTime)) return false;

  //check if service will be completed after employee's shift ends
  selectedTime = selectedTime.add(serviceTime);
  if (timeComesAfter(selectedTime.add(serviceTime), workingDay.endTime))
    return false;

  return true;
}

String getFullWeekday(String weekday) {
  switch (weekday) {
    case 'Mon':
      return 'Monday';
    case 'Tue':
      return 'Tuesday';
    case 'Wed':
      return 'Wednesday';
    case 'Thu':
      return 'Thursday';
    case 'Fri':
      return 'Friday';
    case 'Sat':
      return 'Saturday';
    case 'Sun':
      return 'Sunday';
    default:
      return 'Sunday';
  }
}

String getMonth(int month) {
  switch (month) {
    case 1:
      return 'January';
    case 2:
      return 'February';
    case 3:
      return 'March';
    case 4:
      return 'April';
    case 5:
      return 'May';
    case 6:
      return 'June';
    case 7:
      return 'July';
    case 8:
      return 'August';
    case 9:
      return 'September';
    case 10:
      return 'October';
    case 11:
      return 'November';
    case 12:
      return 'December';
    default:
      return 'January';
  }
}

List<DateTime> generateBookingDays(int daysInAdvance) {
  var referenceDay = DateTime.now();
  var days = <DateTime>[]..add(referenceDay);

  for (int i = 0; i < daysInAdvance; i++) {
    referenceDay = referenceDay.add(Duration(days: 1));
    days.add(referenceDay);
  }

  return days;
}

Duration computeDuration(List<Service> services, List<bool> isSelected) {
  int hours = 0;
  int minutes = 0;

  for (int i = 0; i < isSelected.length; i++) {
    if (isSelected[i]) {
      DateTime duration = DateTime.parse(services[i].duration);
      hours += duration.hour;
      minutes = duration.minute;
    }
  }

  return Duration(hours: hours, minutes: minutes);
}

double computeFee(List<Service> services, List<bool> isSelected) {
  double totalFee = 0;

  for (int i = 0; i < isSelected.length; i++)
    if (isSelected[i]) totalFee += services[i].price;

  return totalFee;
}

bool validBooking(List<Booking> slots, DateTime startTime, Duration duration) {
  DateTime endTime = startTime.add(duration);

  while (startTime.isBefore(endTime)) {
    var slot = slots.firstWhere(
        (booking) =>
            booking.date.hour == startTime.hour &&
            booking.date.minute == startTime.minute,
        orElse: () => null);

    if (slot == null || slot.bookingID.isNotEmpty)
      return false;
    else
      startTime = startTime.add(Duration(minutes: 15));
  }

  return true;
}

List<Booking> generateBookingSlots(DateTime day, String start, String end) {
  var slots = <Booking>[];
  var intervals = Duration(minutes: 15);

  var reference = DateTime.parse(start);
  DateTime startTime = DateTime.utc(
      day.year, day.month, day.day, reference.hour, reference.minute);

  reference = DateTime.parse(end);
  DateTime endTime = DateTime.utc(
      day.year, day.month, day.day, reference.hour, reference.minute);

  while (startTime.isBefore(endTime)) {
    var slot =
        Booking(bookingID: '', clientID: '', date: startTime, employeeID: '');

    slots.add(slot);
    startTime = startTime.add(intervals);
  }

  return slots;
}

//Input time cannot be '00:00' otherwise function will fail
String datetimeToString(DateTime time) {
  String unformattedTime = time.toString().split(' ').last;
  String hours = unformattedTime.split(':').first;
  String minutes = unformattedTime.split(':')[1];

  String formattedTime = '';

  if (hours != '00') {
    hours = int.parse(hours).toString(); //removes padded zeros
    formattedTime += '$hours ' + (hours == '1' ? 'hr ' : 'hrs ');
  }

  if (minutes != '00') {
    minutes = int.parse(minutes).toString(); //removes padded zeros
    formattedTime += '$minutes ' + (minutes == '1' ? 'min' : 'mins');
  }

  return formattedTime;
}

bool timeComesBefore(DateTime dateA, DateTime dateB) {
  if (dateA.hour < dateB.hour)
    return true;
  else if (dateA.hour == dateB.hour && dateA.minute < dateB.minute)
    return true;
  else
    return false;
}

bool timeComesAfter(DateTime dateA, DateTime dateB) {
  if (dateA.hour > dateB.hour)
    return true;
  else if (dateA.hour == dateB.hour && dateA.minute > dateB.minute)
    return true;
  else
    return false;
}

bool timesAreEqual(DateTime timeA, DateTime timeB) {
  return (timeA.hour == timeB.hour && timeA.minute == timeB.minute);
}

String formatTime(DateTime time) {
  String unformattedTime = time.toString().split(' ').last;
  String hours = unformattedTime.split(':').first.padLeft(2, '0');
  String minutes = unformattedTime.split(':')[1].padLeft(2, '0');

  String formattedTime = '$hours : $minutes';

  return formattedTime;
}

String formatDay(String unformattedDay) {
  String day = unformattedDay.split(' ').first.split('-').elementAt(2);
  String intMonth = unformattedDay.split(' ').first.split('-').elementAt(1);
  String month = getMonth(int.parse(intMonth));
  String formattedDay = day + ' ' + month.substring(0, 3);
  return formattedDay;
}
