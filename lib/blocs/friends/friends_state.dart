import 'dart:async';

import 'package:meta/meta.dart';
import 'package:slsywc19/models/user.dart';

@immutable
abstract class FriendsState {}

class InitialFriendsState extends FriendsState {
  final List<FriendUser> cachedFriends;

  InitialFriendsState(this.cachedFriends);
}

class FetchedFriendsState extends FriendsState {
  final List<FriendUser> friends;
  FetchedFriendsState(this.friends);
}

class WaitingFetchingFriendsState extends FriendsState {}

class ErrorFetchingFriendsState extends FriendsState {
  final String msg;

  ErrorFetchingFriendsState(this.msg);
}

class OpenedFriendsState extends FriendsState {
  final Stream<List<FriendUser>> friendsStream;

  OpenedFriendsState(this.friendsStream);
}

class ErrorOpeningFriendsState extends FriendsState {
  final String msg;

  ErrorOpeningFriendsState(this.msg);
}

class ClosedFriendsState extends FriendsState {}
