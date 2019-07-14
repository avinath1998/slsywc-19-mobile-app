import 'package:firebase_auth/firebase_auth.dart';

abstract class User {
  String id;
  String displayName;
  String email;
  String photo;
}

class FriendUser extends User {
  String mobileNo;
  String friendshipId;

  static FriendUser fromFirebaseUser(FirebaseUser user) {
    FriendUser currentUser = new FriendUser();
    currentUser.id = user.uid;
    currentUser.email = user.email;
    return currentUser;
  }

  static FriendUser fromMap(Map<String, dynamic> map, String id) {
    FriendUser friendsUser = new FriendUser();
    friendsUser.id = id;
    friendsUser.displayName = map['name'];
    friendsUser.mobileNo = map['mobileNo'];
    friendsUser.photo = map['photo'];
    friendsUser.email = map['email'];
    friendsUser.friendshipId = id;

    return friendsUser;
  }

  @override
  bool operator ==(Object other) {
    if (other is FriendUser) {
      return this.friendshipId == other.friendshipId;
    } else {
      return false;
    }
  }
}

class CurrentUser extends User {
  int totalPoints;
  int balancePoints;
  List<dynamic> redeemedPrizes;

  static CurrentUser fromFirebaseUser(FirebaseUser user) {
    CurrentUser currentUser = new CurrentUser();
    currentUser.id = user.uid;
    currentUser.email = user.email;
    return currentUser;
  }

  static CurrentUser fromMap(Map<String, dynamic> map, String id) {
    CurrentUser currentUser = new CurrentUser();
    currentUser.id = id;
    currentUser.balancePoints = map['balancePoints'];
    currentUser.displayName = map['name'];
    currentUser.redeemedPrizes = map['redeemedPrizes'];
    currentUser.totalPoints = map['totalPoints'];
    return currentUser;
  }

  @override
  bool operator ==(Object other) {
    if (other is CurrentUser) {
      return this.id == other.id;
    } else {
      return false;
    }
  }
}
