class UserNotFoundException implements Exception {
  final String msg;

  UserNotFoundException(this.msg);
}
