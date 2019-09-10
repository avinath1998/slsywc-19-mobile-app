import 'package:meta/meta.dart';

@immutable
abstract class PointsEvent {}

class FetchPointsEvent extends PointsEvent {}

class OpenPointsEvent extends PointsEvent {
  final int val;

  OpenPointsEvent(this.val);
}
