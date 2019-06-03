import 'package:meta/meta.dart';

@immutable
abstract class HomeTabState {}

class InitialHomeTabState extends HomeTabState {}

class TimelineTabState extends HomeTabState {}

class FriendsTabState extends HomeTabState {}

class MeTabState extends HomeTabState {}

class PrizeTabState extends HomeTabState {}
