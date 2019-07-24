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

  void fetchFriends() {
    dispatch(FetchFriendsEvent());
  }

  void openFriendsStream() {
    dispatch(OpenFriendsEvent());
  }

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
    if (event is FetchFriendsEvent) {
      yield* _fetchFriends();
    } else if (event is DeleteFriendEvent) {
      yield* _deleteFriend(event.friend);
    } else if (event is OpenFriendsEvent) {
      yield* _openFriendsStream();
    }
  }

  Stream<FriendsState> _fetchFriends() async* {
    try {
      print("Fetching Friends");
      if (dataRepository.cachedFriends == null) {
        yield WaitingFetchingFriendsState();
      }
      List<FriendUser> friends = await dataRepository.fetchFriends(user.id);
      yield FetchedFriendsState(friends);
    } on DataFetchException catch (e) {
      print("Error fetching friends: ${e.toString()}");
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

  Stream<FriendsState> _openFriendsStream() async* {
    try {
      print("OPENING FRIENDS STREAM");
      if (dataRepository.cachedFriends == null) {
        yield WaitingFetchingFriendsState();
      }

      Stream<List<FriendUser>> friends =
          dataRepository.openFriendsStream(user.id);

      // yield FetchedFriendsState(friends);

    } catch (e) {
      yield ErrorFetchingFriendsState(e.toString());
      dataRepository.closeFriendsStream();
      print("Error fetching friends: ${e.toString()}");
    }
  }

  @override
  void dispose() {
    super.dispose();
    dataRepository.closeFriendsStream();
    print("CLOSING FRIENDS STREAM");
  }
}
