import 'package:slsywc19/models/user.dart';

class UserAlreadyExistsAsFriendException implements Exception {
  final String msg;
  final FriendUser friendUser;

  UserAlreadyExistsAsFriendException(this.msg, this.friendUser);
}
