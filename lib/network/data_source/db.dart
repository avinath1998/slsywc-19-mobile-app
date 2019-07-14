import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slsywc19/exceptions/data_fetch_exception.dart';
import 'package:slsywc19/models/event.dart';
import 'package:slsywc19/models/prize.dart';
import 'package:slsywc19/models/speaker.dart';
import 'package:slsywc19/models/user.dart';

abstract class DB {
  Future<List<Event>> fetchEvents(int day);
  Event fetchEvent(String eventId);
  Speaker fetchSpeaker(String speakerId);
  Future<CurrentUser> fetchUser(String id);
  Future<List<Prize>> fetchPrizes(String id);
  void closePrizeStream();
  Future<int> fetchPoints(String id);
  void closePointsStream();
}

class FirestoreDB extends DB {
  StreamController _prizeStreamController;
  StreamSubscription _prizeStreamSubscription;
  StreamController _pointsStreamController;
  StreamSubscription _pointsStreamSubscription;

  @override
  Event fetchEvent(String eventId) {
    return null;
  }

  @override
  Future<List<Event>> fetchEvents(int day) async {
    QuerySnapshot ref = await Firestore.instance
        .collection("events")
        .where('day', isEqualTo: day)
        .orderBy('startTime')
        .getDocuments();
    List<Event> events = new List();
    ref.documents.forEach((fetchedEvent) {
      Event event = Event.fromMap(fetchedEvent.data, fetchedEvent.documentID);
      events.add(event);
    });

    // for (int i = 0; i < events.length; i++) {
    //   await Firestore.instance
    //       .collection("events")
    //       .document('${events[i].id}')
    //       .delete();
    // }
    int x = 1;
    int s = 7;
    int timer = 0;

    // for (int i = 0; i < 30; i++) {
    //   Event eventNew = events[0];
    //   eventNew.day = x;
    //   x++;
    //   if (x > 3) {
    //     x = 1;
    //   }
    //   eventNew.title = "Conference Title $s";
    //   eventNew.image = "https://picsum.photos/id/$s/900/600";
    //   s++;
    //   timer++;
    //   if (timer == 24) {
    //     timer = 0;
    //   }
    //   events[0].startTime =
    //       DateTime(2019, 3, 3, timer, 30).millisecondsSinceEpoch;
    //   events[0].startTime =
    //       DateTime(2019, 3, 3, timer + 1, 45).millisecondsSinceEpoch;

    //   Firestore.instance.collection("events").add(Event.toMap(eventNew));
    // }

    return events;
  }

  @override
  Speaker fetchSpeaker(String speakerId) {
    // TODO: implement fetchSpeaker
    return null;
  }

  @override
  Future<CurrentUser> fetchUser(String id) async {
    DocumentSnapshot sp =
        await Firestore.instance.collection("users").document(id).get();
    CurrentUser user = CurrentUser.fromMap(sp.data, sp.documentID);
    return user;
  }

  @override
  Future<List<Prize>> fetchPrizes(String id) async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection("users")
        .document(id)
        .collection("redeemedPrizes")
        .orderBy("value", descending: false)
        .getDocuments();
    List<Prize> prizes = new List();
    snapshot.documents.forEach((dc) {
      prizes.add(UserPrize.fromMap(dc.data, dc.documentID));
    });
    return prizes;
  }

  @override
  void closePrizeStream() {
    print("CLOSING THE PRIZE STREAM");
    _prizeStreamController.close();
    _prizeStreamSubscription.cancel();
  }

  @override
  Future<int> fetchPoints(String id) async {
    DocumentSnapshot sp =
        await Firestore.instance.collection("users").document(id).get();
    if (sp != null) {
      CurrentUser user = CurrentUser.fromMap(sp.data, sp.documentID);
      return user.balancePoints;
    }
    return null;
  }

  @override
  void closePointsStream() {
    _pointsStreamController.close();
    _pointsStreamSubscription.cancel();
  }
}
