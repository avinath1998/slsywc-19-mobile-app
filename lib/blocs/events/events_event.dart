import 'package:meta/meta.dart';

@immutable
abstract class EventsEvent {}

class FetchEventsEvent extends EventsEvent {
  final int day;

  FetchEventsEvent(this.day);
}
