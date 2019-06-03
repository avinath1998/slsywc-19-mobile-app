import 'package:meta/meta.dart';

@immutable
abstract class AuthEvent {}

class SignInEvent extends AuthEvent {}

class SignOutEvent extends AuthEvent {}

class InitialSignInEvent extends AuthEvent {}
