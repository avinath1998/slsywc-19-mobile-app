import 'package:meta/meta.dart';
import 'package:slsywc19/models/user.dart';

@immutable
abstract class MeState {}

class InitialMeState extends MeState {}

class EditingMyDetailsState extends MeState {
  final CurrentUser currentUser;

  EditingMyDetailsState(this.currentUser);
}

class SuccessSavingMyDetailsState extends MeState {
  final CurrentUser currentUser;

  SuccessSavingMyDetailsState(this.currentUser);
}

class ErrorSavingMyDetailsState extends MeState {
  final CurrentUser currentUser;

  ErrorSavingMyDetailsState(this.currentUser);
}

class SavingMyDetailsState extends MeState {
  final CurrentUser currentUser;

  SavingMyDetailsState(this.currentUser);
}

class ViewMyDetailsState extends MeState {
  final CurrentUser currentUser;

  ViewMyDetailsState(this.currentUser);
}
