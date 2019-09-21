import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:slsywc19/models/user.dart';
import 'package:slsywc19/network/repository/ieee_data_repository.dart';
import './friends.dart';
import 'package:slsywc19/exceptions/data_fetch_exception.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  int currentDay;
  IEEEDataRepository dataRepository;
  CurrentUser user;

  FriendsBloc(this.dataRepository, this.user, {this.currentDay});

  void deleteFriend(FriendUser friend) {
    dispatch(DeleteFriendEvent(friend));
  }

  @override
  FriendsState get initialState =>
      InitialFriendsState(dataRepository.cachedFriends);

  @override
  Stream<FriendsState> mapEventToState(
    FriendsEvent event,
  ) async* {
    if (event is DeleteFriendEvent) {
      yield* _deleteFriend(event.friend);
    } else if (event is UpdatedFriendsEvent) {
      yield FetchedFriendsState(event.friends);
    } else if (event is FriendsStreamOpeningException) {
      yield ErrorFetchingFriendsState(event.e.toString());
    }
  }

  Stream<FriendsState> _deleteFriend(
    FriendUser friend,
  ) async* {
    print("Deleting a user");
    try {
      dataRepository.deleteFriend(user.id, friend);
      yield FetchedFriendsState(dataRepository.cachedFriends);
      print("Deleted user ${friend.id}");
    } on DataFetchException catch (e) {
      print("Error deleting user ${e.msg}");
    }
  }

  void openFriendsStream() {
    try {
      print("OPENING FRIENDS STREAM");
      dataRepository.openFriendsStream(user.id, (friendsList) {
        dispatch(UpdatedFriendsEvent(friendsList));
      });
    } catch (e) {
      dispatch(FriendsStreamOpeningException(e));
      dataRepository.closeFriendsStream();
      print("Error opening friends: ${e.toString()}");
    }
  }

  @override
  void dispose() {
    super.dispose();
    dataRepository.closeFriendsStream();
    print("CLOSING FRIENDS STREAM");
  }
}
