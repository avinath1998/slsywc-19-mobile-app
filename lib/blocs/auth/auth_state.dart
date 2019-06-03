import 'package:meta/meta.dart';

@immutable
abstract class AuthState {}

class InitialAuthState extends AuthState {}

class SignedInState extends AuthState {}

class SignedOutState extends AuthState {}

class AuthenticationLoadingState extends AuthState {}

class AuthenticationErrorState extends AuthState {
  final String errorMsg;

  AuthenticationErrorState(this.errorMsg);
}
