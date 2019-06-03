import 'package:firebase_auth/firebase_auth.dart';

abstract class User {
  String id;
  String displayName;
  String email;
}

class CurrentUser extends User {
  static CurrentUser fromFirebaseUser(FirebaseUser user) {
    CurrentUser currentUser = new CurrentUser();
    currentUser.id = user.uid;
    currentUser.displayName = user.displayName;
    currentUser.email = user.email;
    return currentUser;
  }
}
