import 'package:meta/meta.dart';
import 'package:slsywc19/models/user.dart';

@immutable
abstract class FriendsEvent {}

class FetchFriendsEvent extends FriendsEvent {}

class DeleteFriendEvent extends FriendsEvent {
  final FriendUser friend;

  DeleteFriendEvent(this.friend);
}
