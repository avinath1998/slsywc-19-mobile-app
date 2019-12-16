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
  int friendshipCreatedTime;

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
    friendsUser.mobileNo = map['phoneNumber'];
    friendsUser.photo = map['profilePic'];
    friendsUser.email = map['email'];
    friendsUser.friendshipCreatedTime = map['friendshipCreatedTime'];
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

  static Map<String, dynamic> toMap(FriendUser user) {
    Map<String, dynamic> map = new Map();
    map['name'] = user.displayName;
    map['phoneNumber'] = user.mobileNo;
    map['profilePic'] = user.photo;
    map['email'] = user.email;
    map['id'] = user.id;
    map['friendshipCreatedTime'] = user.friendshipCreatedTime;
    return map;
  }
}

class CurrentUser extends User {
  int totalPoints;
  int balancePoints;
  int currentAcademicYear;
  int currentConferenceCount;
  String studentBranchName;
  String ieeeMembershipNo;
  String profilePic;
  String phoneNumber;

  List<dynamic> redeemedPrizes;

  static CurrentUser fromFirebaseUser(FirebaseUser user) {
    CurrentUser currentUser = new CurrentUser();
    currentUser.id = user.uid;
    currentUser.email = user.email;
    currentUser.displayName = user.displayName;
    currentUser.profilePic = user.photoUrl;
    currentUser.profilePic =
        currentUser.profilePic.replaceAll("s96-c", "s400-c");
    print("PHOTOURL " + currentUser.profilePic);
    return currentUser;
  }

  static CurrentUser fromMap(Map<String, dynamic> map, String id) {
    CurrentUser currentUser = new CurrentUser();
    currentUser.id = id;
    currentUser.balancePoints = map['balancePoints'];
    currentUser.displayName = map['name'];
    currentUser.profilePic = map['profilePic'];
    currentUser.redeemedPrizes = map['redeemedPrizes'];
    currentUser.totalPoints = map['totalPoints'];
    currentUser.currentAcademicYear = map['currentAcademicYear'];
    currentUser.currentConferenceCount = map['currentConferenceCount'];
    currentUser.studentBranchName = map['studentBranchName'];
    currentUser.ieeeMembershipNo = map['ieeeMembershipNo'];
    currentUser.phoneNumber = map['phoneNumber'];
    currentUser.email = map['email'];
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
