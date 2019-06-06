import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:slsywc19/models/event.dart';
import 'package:slsywc19/models/user.dart';
import 'package:slsywc19/network/repository/ieee_data_repository.dart';
import 'package:slsywc19/exceptions/data_fetch_exception.dart';

import './events.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final IEEEDataRepository dataRepository;
  final CurrentUser user;
  final String _TAG = "TimelineBloc";
  final int currentDay;

  EventsBloc(this.dataRepository, this.user, {this.currentDay});

  void fetchEvents() {
    dispatch(FetchEventsEvent());
  }

  @override
  Stream<EventsState> mapEventToState(EventsEvent event) async* {
    if (event is FetchEventsEvent) {
      yield* _fetchEvent();
    }
  }

  @override
  EventsState get initialState => InitialEventsState(
      fetchedEvents: dataRepository.hasFetchedDay(currentDay)
          ? dataRepository.getEventsForDay(currentDay)
          : null);

  Stream<EventsState> _fetchEvent() async* {
    yield LoadingFetchingEventsState();
    try {
      List<Event> fetchedEvents = await dataRepository.fetchEvents(currentDay);
      yield SuccessFetchingEventsState(fetchedEvents);
    } on DataFetchException catch (e) {
      print("$_TAG an error has occured fetching events: ${e.toString()}");
      yield ErrorFetchingEventsState(e.toString());
    }
  }
}
