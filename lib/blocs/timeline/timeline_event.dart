import 'package:meta/meta.dart';

@immutable
abstract class TimelineEvent {}

class SwitchDay extends TimelineEvent {
  final int day;

  SwitchDay(this.day);
}
