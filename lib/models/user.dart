import 'package:firebase_auth/firebase_auth.dart';

abstract class User {
  String id;
  String displayName;
  String email;
}

class CurrentUser extends User {
  int totalPoints;
  int balancePoints;
  List<dynamic> redeemedPrizes;
  List<String> friends;

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
}
