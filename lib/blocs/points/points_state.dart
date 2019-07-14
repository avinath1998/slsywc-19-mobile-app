import 'package:meta/meta.dart';

@immutable
abstract class PointsState {}

class InitialPointsState extends PointsState {
  final int points;

  InitialPointsState(this.points);
}

class FetchedPointsState extends PointsState {
  final int points;

  FetchedPointsState(this.points);
}

class WaitingFetchingPointsState extends PointsState {
  final int points;

  WaitingFetchingPointsState(this.points);
}

class PointsErrorState extends PointsState {
  final String msg;

  PointsErrorState(this.msg);
}
