import 'package:meta/meta.dart';

@immutable
abstract class RegistrationState {}

class InitialRegistrationState extends RegistrationState {}

class RegistrationSuccessfulState extends RegistrationState {}

class RegistrationErrorState extends RegistrationState {}

class RegistrationWaitingState extends RegistrationState {}
