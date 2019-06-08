import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  Stream<List<Prize>> streamPrizes(String id);
  void closePrizeStream();
}

class FirestoreDB extends DB {
  StreamController _prizeStreamController;
  StreamSubscription _prizeStreamSubscription;

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
  Future<List<Prize>> fetchPrizes(String id) {
    return null;
  }

  @override
  Stream<List<Prize>> streamPrizes(String id) {
    _prizeStreamController = new StreamController<List<Prize>>();
    _prizeStreamSubscription = Firestore.instance
        .collection("users")
        .document(id)
        .collection("redeemedPrizes")
        .snapshots()
        .listen((sp) {
      List<Prize> prizes = new List();
      sp.documents.forEach((ec) {
        UserPrize prize = UserPrize.fromMap(ec.data, ec.documentID);
        prizes.add(prize);
      });
      _prizeStreamController.add(prizes);
    });

    return _prizeStreamController.stream;
  }

  @override
  void closePrizeStream() {
    _prizeStreamController.close();
    _prizeStreamSubscription.cancel();
  }
}
