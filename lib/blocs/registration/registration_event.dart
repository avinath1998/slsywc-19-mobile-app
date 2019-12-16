import 'package:meta/meta.dart';
import 'package:slsywc19/models/user.dart';

@immutable
abstract class RegistrationEvent {}

class RegisterUserEvent extends RegistrationEvent {
  final CurrentUser user;
  RegisterUserEvent(this.user);
}
