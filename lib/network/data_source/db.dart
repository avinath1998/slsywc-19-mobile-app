import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slsywc19/exceptions/data_fetch_exception.dart';
import 'package:slsywc19/exceptions/user_already_exists_as_friend_exception.dart';
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
  Future<List<FriendUser>> fetchFriends(String id);
  void deleteFriend(String id, FriendUser friend);
  StreamController<List<FriendUser>> openFriends(String id);
  StreamController<List<Prize>> openPrizesStream(String id);
  StreamController<int> openPointsStream(String id);
  void closePrizesStream();
  void closeFriends();
  Future<void> updatePoints(int points, String id);
  Future<void> addFriend(String currentUserId, String friendUserId);
}

class FirestoreDB extends DB {
  StreamController<List<Prize>> _prizeStreamController;
  StreamSubscription _prizeStreamSubscription;
  StreamController<int> _pointsStreamController;
  StreamSubscription _pointsStreamSubscription;

  StreamController<List<FriendUser>> friendsStream;
  StreamSubscription friendsSub;

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

    // for (int i = 0; i < 10; i++) {
    //   await Firestore.instance
    //       .collection("users")
    //       .document(id)
    //       .collection("friends")
    //       .add({
    //     'id': "$i",
    //     'name': 'Bruna Marquezine',
    //     'email': 'manage@gmail.com',
    //     'mobileNo': '0768043101',
    //     'photo': "https://data.whicdn.com/images/253203194/large.jpg"
    //   });
    // }

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
      return user.totalPoints;
    }
    return null;
  }

  @override
  void closePointsStream() {
    _pointsStreamController.close();
    _pointsStreamSubscription.cancel();
  }

  @override
  Future<List<FriendUser>> fetchFriends(String id) async {
    print("DB: Friends are being fetched");
    QuerySnapshot sp = await Firestore.instance
        .collection("users")
        .document(id)
        .collection("friends")
        .getDocuments();
    List<FriendUser> friends = new List();
    if (sp.documents != null) {
      sp.documents.forEach((snapshot) {
        if (snapshot != null) {
          FriendUser user =
              FriendUser.fromMap(snapshot.data, snapshot.documentID);
          friends.add(user);
        }
      });
    }
    return friends;
  }

  @override
  void deleteFriend(String id, FriendUser friend) async {
    await Firestore.instance
        .collection("users")
        .document(id)
        .collection("friends")
        .document(friend.friendshipId)
        .delete();
  }

  @override
  StreamController<List<FriendUser>> openFriends(String id) {
    try {
      friendsStream = new StreamController();
      friendsSub = Firestore.instance
          .collection("users")
          .document(id)
          .collection("friends")
          .snapshots()
          .listen((dc) {
        print("Friends Stream Active");

        if (dc != null) {
          List<FriendUser> friends = new List();
          dc.documents.forEach((d) {
            FriendUser friend = FriendUser.fromMap(d.data, d.documentID);
            friends.add(friend);
            print(friend.displayName);
          });

          friendsStream.add(friends);
        }
      });
      return friendsStream;
    } catch (e) {
      throw DataFetchException(e.toString());
    }
  }

  @override
  void closeFriends() {
    if (friendsStream != null && friendsSub != null) {
      friendsStream.close();
      friendsSub.cancel();
    }
  }

  @override
  Future<void> updatePoints(int points, String id) async {
    print("Updating points");
    final DocumentReference docRef =
        Firestore.instance.collection("users").document(id);
    Map<String, dynamic> transactionData =
        await Firestore.instance.runTransaction((tx) async {
      DocumentSnapshot sp = await tx.get(docRef);
      if (sp.exists) {
        int oldPoints = sp.data['totalPoints'];
        await tx.update(docRef, {'totalPoints': oldPoints + points});
        return {'status': 'success'};
      } else {
        print("Updating points, the retrieved snapshot doesnt exist");
      }
      return {'status': 'failed'};
    });
    if (transactionData['status'] == "failed") {
      throw DataFetchException("Failed to update the user poitns");
    }
  }

  Future<bool> _doesFriendUserExistAsFriend(
      String currentUserId, String friendsUserId) async {
    QuerySnapshot sp = await Firestore.instance
        .collection("users")
        .document(currentUserId)
        .collection("friends")
        .where("id", isEqualTo: friendsUserId)
        .getDocuments();
    print("USER FRIENDS: ${sp.documents.length}");
    return sp.documents.length != 0;
  }

  @override
  Future<void> addFriend(String currentUserId, String friendsUserId) async {
    print("Updating friends");
    final CollectionReference currentUserColRef = Firestore.instance
        .collection("users")
        .document(currentUserId)
        .collection("friends");
    if (!await _doesFriendUserExistAsFriend(currentUserId, friendsUserId)) {
      final DocumentReference friendUserDocRef =
          Firestore.instance.collection("users").document(friendsUserId);
      DocumentSnapshot friendSnap = await friendUserDocRef.get();
      if (friendSnap != null) {
        if (friendSnap.data != null) {
          FriendUser friendUser =
              FriendUser.fromMap(friendSnap.data, friendSnap.documentID);

          Map<String, dynamic> transactionData =
              await Firestore.instance.runTransaction((tx) async {
            currentUserColRef.add(FriendUser.toMap(friendUser));
            return {'status': 'success'};
          });

          if (transactionData['status'] == "failed") {
            throw DataFetchException("Failed to update the user poitns");
          }
        } else {
          throw DataFetchException("Friend could not be fetched");
        }
      } else {
        throw DataFetchException("Friend could not be fetched");
      }
    } else {
      throw UserAlreadyExistsAsFriendException(
          "User already exists as friend $friendsUserId");
    }
  }

  @override
  StreamController<List<Prize>> openPrizesStream(String id) {
    if (_prizeStreamController == null || _prizeStreamController.isClosed) {
      _prizeStreamController = new StreamController();
    }
    _prizeStreamSubscription = Firestore.instance
        .collection('users')
        .document(id)
        .collection('redeemedPrizes')
        .snapshots()
        .listen((dc) {
      print("Update");
      List<Prize> prizes = new List();
      dc.documents.forEach((dc) {
        prizes.add(UserPrize.fromMap(dc.data, dc.documentID));
      });
      _prizeStreamController.add(prizes);
    });
    return _prizeStreamController;
  }

  @override
  void closePrizesStream() {
    print("CLOSEING Prize Stream in DB");
    _prizeStreamController.close();
    _prizeStreamSubscription.cancel();
  }

  @override
  StreamController<int> openPointsStream(String id) {
    print('DB: Opening Points Stream');
    if (_pointsStreamController == null || _pointsStreamController.isClosed) {
      _pointsStreamController = new StreamController();
    }
    _pointsStreamSubscription = Firestore.instance
        .collection("users")
        .document(id)
        .snapshots()
        .listen((dc) {
      print("Points Update has arrived");

      CurrentUser user = CurrentUser.fromMap(dc.data, dc.documentID);
      _pointsStreamController.add(user.balancePoints);
    });
    return _pointsStreamController;
  }
}
