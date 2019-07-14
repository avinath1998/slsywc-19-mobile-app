import 'dart:async';

import 'package:slsywc19/exceptions/data_fetch_exception.dart';
import 'package:slsywc19/models/event.dart';
import 'package:slsywc19/models/prize.dart';
import 'package:slsywc19/models/user.dart';
import 'package:slsywc19/network/data_source/db.dart';

class IEEEDataRepository {
  static final IEEEDataRepository _repo = new IEEEDataRepository._internal();

  static IEEEDataRepository get() {
    return _repo;
  }

  IEEEDataRepository._internal() {
    _db = FirestoreDB();
  }

  DB _db;
  String _TAG = "IEEEDataRepository: ";
  List<Event> dayOneEvents = List();
  List<Event> dayTwoEvents = List();
  List<Event> dayThreeEvents = List();

  bool _hasFetchedFirstDay = false;
  bool _hasFetchedSecondDay = false;
  bool _hasFetchedThirdDay = false;

  List<Prize> cachedPrizes;
  int cachedPoints = 0;
  List<FriendUser> cachedFriends;

  Future<List<Prize>> fetchPrizes(String id) async {
    try {
      List<Prize> prizes = await _db.fetchPrizes(id);
      if (prizes.length > 0 && cachedPrizes == null) {
        cachedPrizes = new List();
      }
      if (cachedPrizes != null) {
        cachedPrizes.clear();
        prizes.forEach((p) {
          cachedPrizes.add(p);
        });
      }
      return prizes;
    } catch (e) {
      throw DataFetchException(e.toString());
    }
  }

  Future<List<FriendUser>> fetchFriends(String id) async {
    print("Fetching friends");
    try {
      List<FriendUser> users = await _db.fetchFriends(id);
      if (cachedFriends == null && users.length > 0) {
        cachedFriends = List();
      }

      //a cachedFriends list can only be instantiated if the retrieved friends list is greater than zero and a list is non existent
      if (cachedFriends != null) {
        cachedFriends.clear();
        users.forEach((u) {
          cachedFriends.add(u);
        });
      }
      return users;
    } catch (e) {
      print(e.toString());
      throw DataFetchException(e.toString());
    }
  }

  Future<CurrentUser> fetchUser(String id) async {
    print("Fetching User with ID: " + id);
    try {
      CurrentUser user = await _db.fetchUser(id);
      return user;
    } catch (e) {
      print(e.toString());
      throw DataFetchException(e.toString());
    }
  }

  Future<int> fetchPoints(String id) async {
    try {
      int _points = await _db.fetchPoints(id);
      cachedPoints = _points;
      return _points;
    } catch (e) {
      throw DataFetchException(e.toString());
    }
  }

  bool hasFetchedDay(int day) {
    switch (day) {
      case 1:
        return _hasFetchedFirstDay;
      case 2:
        return _hasFetchedSecondDay;
      case 3:
        return _hasFetchedThirdDay;
      default:
        return false;
    }
  }

  List<Event> getEventsForDay(int day) {
    switch (day) {
      case 1:
        return dayOneEvents;
      case 2:
        return dayTwoEvents;
      case 3:
        return dayThreeEvents;
      default:
        return null;
    }
  }

  Future<List<Event>> fetchEvents(int requiredDay) async {
    try {
      if ((requiredDay == 1 && !_hasFetchedFirstDay) ||
          (requiredDay == 2 && !_hasFetchedSecondDay) ||
          (requiredDay == 3 && !_hasFetchedThirdDay)) {
        print("$_TAG Fetching Events: ${requiredDay}");

        List<Event> events = await _db.fetchEvents(requiredDay);
        if (requiredDay == 1) {
          _hasFetchedFirstDay = true;
        } else if (requiredDay == 2) {
          _hasFetchedSecondDay = true;
        } else if (requiredDay == 3) {
          _hasFetchedThirdDay = true;
        }
        print("$_TAG Fetched Events: ${events.length}");
        events.forEach((event) {
          switch (event.day) {
            case 1:
              if (!dayOneEvents.contains(event)) {
                dayOneEvents.add(event);
              }
              break;
            case 2:
              if (!dayTwoEvents.contains(event)) {
                dayTwoEvents.add(event);
              }
              break;
            case 3:
              if (!dayThreeEvents.contains(event)) {
                dayThreeEvents.add(event);
              }
              break;
          }
        });
      } else {
        print("$_TAG Data has already been fetched: ${requiredDay}");
      }
      switch (requiredDay) {
        case 1:
          return dayOneEvents;
        case 2:
          return dayTwoEvents;
        case 3:
          return dayThreeEvents;
        default:
          return dayOneEvents;
      }
    } catch (e) {
      print("$_TAG an error has occured fetching events: ${e.toString()}");
      throw new DataFetchException(e.toString());
    }
  }

  void deleteFriend(String id, FriendUser friend) {
    print("Deleting a friend");
    try {
      _db.deleteFriend(id, friend);
      cachedFriends.remove(friend);
    } catch (e) {
      throw DataFetchException("Error deleting user");
    }
  }
}
