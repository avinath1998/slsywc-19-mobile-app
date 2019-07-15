class UserAlreadyExistsAsFriendException implements Exception {
  final String msg;

  UserAlreadyExistsAsFriendException(this.msg);
}
