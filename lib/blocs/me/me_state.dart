import 'package:meta/meta.dart';
import 'package:slsywc19/models/user.dart';

@immutable
abstract class MeState {}

class InitialMeState extends MeState {
  final CurrentUser currentUser;

  InitialMeState(this.currentUser);
}

class EditingMyDetailsState extends MeState {
  final CurrentUser currentUser;

  EditingMyDetailsState(
    this.currentUser,
  );
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
  final bool isImageSaving;

  SavingMyDetailsState(this.currentUser, {this.isImageSaving = false});
}

class ViewMyDetailsState extends MeState {
  final CurrentUser currentUser;

  ViewMyDetailsState(this.currentUser);
}
