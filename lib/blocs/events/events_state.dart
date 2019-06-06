import 'package:meta/meta.dart';
import 'package:slsywc19/models/event.dart';

@immutable
abstract class EventsState {}

class InitialEventsState extends EventsState {
  final List<Event> fetchedEvents;

  InitialEventsState({this.fetchedEvents});
}

class SuccessFetchingEventsState extends EventsState {
  final List<Event> fetchedEvents;

  SuccessFetchingEventsState(this.fetchedEvents);
}

class ErrorFetchingEventsState extends EventsState {
  final String errorMsg;

  ErrorFetchingEventsState(this.errorMsg);
}

class LoadingFetchingEventsState extends EventsState {}
