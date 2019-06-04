import 'package:meta/meta.dart';

@immutable
abstract class TimelineState {}

class InitialTimelineState extends TimelineState {}

class DayOneTimelineState extends TimelineState {}

class DayTwoTimelineState extends TimelineState {}

class DayThreeTimelineState extends TimelineState {}

class EventLoadingState extends TimelineState {}

class EventLoadingErrorState extends TimelineState {}
