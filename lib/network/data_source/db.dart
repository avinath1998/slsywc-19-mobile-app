import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:slsywc19/exceptions/data_fetch_exception.dart';
import 'package:slsywc19/exceptions/data_write_exception.dart';
import 'package:slsywc19/exceptions/user_already_exists_as_friend_exception.dart';
import 'package:slsywc19/exceptions/user_not_found_exception.dart';
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
  Future<CurrentUser> registerUser(CurrentUser user);
  Future<FriendUser> addFriend(String currentUserId, String friendUserId);
  Future<String> uploadProfileImage(CurrentUser currentUserId, File image);
  Future<CurrentUser> updateCurrentUser(CurrentUser newUser);
  Future<bool> isRegistered(String email);
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
    if (sp.exists) {
      CurrentUser user = CurrentUser.fromMap(sp.data, sp.documentID);
      return user;
    } else {
      throw UserNotFoundException("user not found");
    }

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
      friendsStream = StreamController();
      friendsSub = Firestore.instance
          .collection("users")
          .document(id)
          .collection("friends")
          .orderBy('friendshipCreatedTime')
          .snapshots()
          .listen((dc) {
        print("Friends Stream Active");

        if (dc != null) {
          List<FriendUser> friends = List();
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

  Future<void> addCurrentUsertoFriend(
      String currentUserId, String friendsUserId) async {
    final DocumentReference currentUserDocRef =
        Firestore.instance.collection("users").document(currentUserId);
    final CollectionReference friendToAddColRef = Firestore.instance
        .collection("users")
        .document(friendsUserId)
        .collection("friends");
    DocumentSnapshot currentUserSnap = await currentUserDocRef.get();
    if (currentUserSnap != null) {
      if (currentUserSnap.data != null) {
        FriendUser currentUserData = FriendUser.fromMap(
            currentUserSnap.data, currentUserSnap.documentID);
        currentUserData.friendshipCreatedTime =
            DateTime.now().millisecondsSinceEpoch;
        Map<String, dynamic> transactionDataCurrent =
            await Firestore.instance.runTransaction((tx) async {
          friendToAddColRef.add(FriendUser.toMap(currentUserData));
        });
        if (transactionDataCurrent['status'] == "failed") {
          throw DataFetchException("Failed to update friend");
        }
      } else {
        throw DataFetchException("Friend could not be fetched");
      }
    } else {
      throw DataFetchException("Friend could not be fetched");
    }
  }

  @override
  Future<FriendUser> addFriend(
      String currentUserId, String friendsUserId) async {
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
          friendUser.friendshipCreatedTime =
              DateTime.now().millisecondsSinceEpoch;
          Map<String, dynamic> transactionData =
              await Firestore.instance.runTransaction((tx) async {
            await currentUserColRef.add(FriendUser.toMap(friendUser));
            await addCurrentUsertoFriend(currentUserId, friendsUserId);
          });
          if (transactionData['status'] == "failed") {
            throw DataFetchException("Failed to update friend");
          } else {
            return friendUser;
          }
        } else {
          throw DataFetchException("Friend could not be fetched");
        }
      } else {
        throw DataFetchException("Friend could not be fetched");
      }
    } else {
      QuerySnapshot sp = await Firestore.instance
          .collection("users")
          .document(currentUserId)
          .collection("friends")
          .where("id", isEqualTo: friendsUserId)
          .getDocuments();
      if (sp.documents.length >= 1) {
        print("Multiple of the same users have been found.");
        DocumentSnapshot dc = sp.documents[0];
        FriendUser friend = FriendUser.fromMap(dc.data, dc.documentID);
        throw UserAlreadyExistsAsFriendException(
            "User already exists as friend $friendsUserId", friend);
      }
    }
  }

  @override
  StreamController<List<Prize>> openPrizesStream(String id) {
    if (_prizeStreamController == null || _prizeStreamController.isClosed) {
      _prizeStreamController = new StreamController();
    }
    print("Fetching User PRizes: $id");
    _prizeStreamSubscription = Firestore.instance
        .collection('users')
        .document(id)
        .collection('redemeedPrizes')
        .orderBy('value')
        .snapshots()
        .listen((dc) {
      List<Prize> prizes = new List();
      dc.documents.forEach((dc) {
        prizes.add(UserPrize.fromMap(dc.data, dc.documentID));
        print("Received Prize: ${dc.documentID}");
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
      _pointsStreamController.add(user.totalPoints);
    });
    return _pointsStreamController;
  }

  @override
  Future<CurrentUser> updateCurrentUser(CurrentUser newUser) async {
    print("Updating Current User");

    Map<String, dynamic> transactionData =
        await Firestore.instance.runTransaction((tx) {
      Firestore.instance.collection("users").document(newUser.id).updateData({
        'ieeeMemberShipNo': newUser.ieeeMembershipNo,
        'studentBranchName': newUser.studentBranchName,
        'currentAcademicYear': newUser.currentAcademicYear,
        'currentConferenceCount': newUser.currentConferenceCount,
        'phoneNumber': newUser.phoneNumber,
        'email': newUser.email
      });
    });

    if (transactionData['status'] == "failed") {
      throw DataWriteException("Failed to update the user details");
    } else {
      return newUser;
    }
  }

  @override
  Future<String> uploadProfileImage(CurrentUser currentUser, File image) async {
    //uploading to the firebase storage
    final StorageReference storageReference = FirebaseStorage()
        .ref()
        .child('images/users/${currentUser.id}/user_images');
    final StorageUploadTask uploadTask = storageReference.putFile(image);
    StorageTaskSnapshot uploadingTask = await uploadTask.onComplete;
    if (uploadingTask.error != null) {
      throw DataWriteException(
          "Error saving user Image: error: ${uploadingTask.error}");
    }

    Map<String, dynamic> transactionData =
        await Firestore.instance.runTransaction((tx) async {
      String url = await uploadingTask.ref.getDownloadURL();
      Firestore.instance
          .collection("users")
          .document(currentUser.id)
          .updateData({'profilePic': url});
    });

    if (transactionData['status'] == "failed") {
      throw DataWriteException("Failed to update the user info");
    }
    return await uploadingTask.ref.getDownloadURL();
  }

  @override
  Future<CurrentUser> registerUser(CurrentUser user) async {
    Map<String, dynamic> transactionData =
        await Firestore.instance.runTransaction((tx) async {
      await Firestore.instance.collection("users").document(user.id).setData({
        'currentAcademicYear': user.currentAcademicYear,
        'currentConferenceCount': user.currentConferenceCount,
        'email': user.email,
        'ieeeMembershipNo': user.ieeeMembershipNo,
        'name': user.displayName,
        'phoneNumber': user.phoneNumber,
        'studentBranchName': user.studentBranchName,
        'profilePic': user.profilePic,
        'totalPoints': 0
      });
      await Firestore.instance
          .collection("users")
          .document(user.id)
          .collection("redemeedPrizes")
          .add({
        'id': 1,
        'image':
            'https://www.gocontigo.com/media/catalog/product/cache/19/image/425x/040ec09b1e35df139433887a97daa66f/1/9/1990081_contigo_cortland_24oz_monaco_34_1.png',
        'isRedeemed': false,
        'title': "Large Bottle",
        'value': 500
      });
    });
    if (transactionData['status'] == "failed") {
      throw DataWriteException("Failed to update the user info");
    }
    return null;
  }

  @override
  Future<bool> isRegistered(String email) async {
    QuerySnapshot sp = await Firestore.instance
        .collection("registeredUsers")
        .where("email", isEqualTo: email)
        .getDocuments();
    print("------------------------------------");
    sp.documents.forEach((dc) {
      print(dc.data);
    });
    print("Number of users found with matching emails: ${sp.documents.length}");
    return sp.documents.length > 0;
  }
}
