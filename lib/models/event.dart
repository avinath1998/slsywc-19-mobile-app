class Event {
  String desc;
  String image;
  String location;
  List<dynamic> speakers;
  String title;
  int time;
  String id;
  int day;

  static Event fromMap(Map<String, dynamic> map, String id) {
    Event event = new Event();
    event.desc = map['desc'];
    event.location = map['location'];
    event.image = map['image'];
    event.time = map['time'];
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
    map['dateAndTime'] = event.time;
    return map;
  }

  DateTime getDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(time);
  }

  DateTime getTimeRange() {
    return DateTime.fromMillisecondsSinceEpoch(time);
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
