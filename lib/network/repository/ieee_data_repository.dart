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
  List<Event> _fetchedEvents = List();
  bool _hasFetchedFirstDay = false;
  bool _hasFetchedSecondDay = false;
  bool _hasFetchedThirdDay = false;

  Future<List<Event>> fetchEvents(int requiredDay) async {
    print(requiredDay);
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
          if (!_fetchedEvents.contains(event)) {
            _fetchedEvents.add(event);
            print("$_TAG Fetched Event: ${event.title}");
          } else {
            print(event.id);
          }
        });
      } else {
        print("$_TAG Data has already been fetched: ${requiredDay}");
      }
      return _fetchedEvents.where((event) {
        return event.day == requiredDay;
      }).toList();
    } catch (e) {
      print("$_TAG an error has occured fetching events: ${e.toString()}");
      throw new DataFetchException(e.toString());
    }
  }
}
