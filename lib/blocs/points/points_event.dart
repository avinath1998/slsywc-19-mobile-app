import 'package:meta/meta.dart';

@immutable
abstract class PointsEvent {}

class FetchPointsEvent extends PointsEvent {}
