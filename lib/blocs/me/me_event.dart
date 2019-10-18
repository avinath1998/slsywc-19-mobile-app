import 'package:meta/meta.dart';
import 'package:slsywc19/models/user.dart';

@immutable
abstract class MeEvent {}

class EditMyDetailsEvent extends MeEvent {}

class EditMyProfilePicEvent extends MeEvent {}

class ViewMyDetailsEvent extends MeEvent {}

class SaveMyDetailsEvent extends MeEvent {
  final CurrentUser newUser;

  SaveMyDetailsEvent(this.newUser);
}
