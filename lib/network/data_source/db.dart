import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slsywc19/models/event.dart';
import 'package:slsywc19/models/speaker.dart';

abstract class DB {
  Future<List<Event>> fetchEvents(int day);
  Event fetchEvent(String eventId);
  Speaker fetchSpeaker(String speakerId);
}

class FirestoreDB extends DB {
  @override
  Event fetchEvent(String eventId) {
    return null;
  }

  @override
  Future<List<Event>> fetchEvents(int day) async {
    QuerySnapshot ref = await Firestore.instance
        .collection("events")
        // .where("day", isEqualTo: day)
        .orderBy("dateAndTime")
        .getDocuments();
    List<Event> events = new List();
    ref.documents.forEach((fetchedEvent) {
      Event event = Event.fromMap(fetchedEvent.data, fetchedEvent.documentID);
      events.add(event);
    });
    // int x = 1;
    // int s = 7;
    // for (int i = 0; i < 100; i++) {
    //   events[0].day = x;
    //   x++;
    //   if (x > 3) {
    //     x = 1;
    //   }
    //   events[0].title = "Conference Number $s";
    //   s++;
    //   events[0].time = DateTime.now().millisecondsSinceEpoch;
    //   Firestore.instance.collection("events").add(Event.toMap(events[0]));
    // }

    return events;
  }

  @override
  Speaker fetchSpeaker(String speakerId) {
    // TODO: implement fetchSpeaker
    return null;
  }
}
