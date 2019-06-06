import 'package:slsywc19/exceptions/data_fetch_exception.dart';
import 'package:slsywc19/models/event.dart';
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
}
