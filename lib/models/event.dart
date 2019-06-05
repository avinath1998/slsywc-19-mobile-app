import 'package:intl/intl.dart';

class Event {
  String desc;
  String image;
  String location;
  List<dynamic> speakers;
  String title;
  int startTime;
  int endTime;
  String id;
  int day;

  static Event fromMap(Map<String, dynamic> map, String id) {
    Event event = new Event();
    event.desc = map['desc'];
    event.location = map['location'];
    event.image = map['image'];
    event.startTime = map['startTime'];
    event.endTime = map['endTime'];
    event.speakers = map['speakers'];
    event.title = map['title'];
    event.id = id;
    event.day = map['day'];
    return event;
  }

  static Map<String, dynamic> toMap(Event event) {
    Map<String, dynamic> map = new Map();
    map['desc'] = event.desc;
    map['location'] = event.location;
    map['image'] = event.image;
    map['speakers'] = event.speakers;
    map['title'] = event.title;
    map['day'] = event.day;
    map['startTime'] = event.startTime;
    map['endTime'] = event.endTime;
    return map;
  }

  DateTime getDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(1);
  }

  String getTimeRangeAsString() {
    DateTime startDateTime = DateTime.fromMillisecondsSinceEpoch(startTime);
    DateTime endDateTime = DateTime.fromMillisecondsSinceEpoch(endTime);
    String startTimeString = DateFormat('hh:mm aa').format(startDateTime);
    String endTimeString = DateFormat('hh:mm aa').format(endDateTime);
    return "$startTimeString - $endTimeString";
  }

  @override
  bool operator ==(Object other) {
    if (other is Event) {
      return this.id == other.id;
    } else {
      return false;
    }
  }
}
