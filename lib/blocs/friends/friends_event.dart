import 'package:meta/meta.dart';
import 'package:slsywc19/exceptions/data_fetch_exception.dart';
import 'package:slsywc19/models/user.dart';

@immutable
abstract class FriendsEvent {}

class DeleteFriendEvent extends FriendsEvent {
  final FriendUser friend;

  DeleteFriendEvent(this.friend);
}

class UpdatedFriendsEvent extends FriendsEvent {
  final List<FriendUser> friends;

  UpdatedFriendsEvent(this.friends);
}

class FriendsStreamOpeningException extends FriendsEvent {
  final Exception e;

  FriendsStreamOpeningException(this.e);
}
