import 'package:meta/meta.dart';
import 'package:slsywc19/models/event.dart';

@immutable
abstract class TimelineState {}

class InitialTimelineState extends TimelineState {}

class DayOneTimelineState extends TimelineState {
  final List<Event> events;

  DayOneTimelineState(this.events);
}

class DayTwoTimelineState extends TimelineState {
  final List<Event> events;

  DayTwoTimelineState(this.events);
}

class DayThreeTimelineState extends TimelineState {
  final List<Event> events;

  DayThreeTimelineState(this.events);
}

class EventLoadingState extends TimelineState {}

class EventLoadingErrorState extends TimelineState {
  final String errorMsg;

  EventLoadingErrorState(this.errorMsg);
}
