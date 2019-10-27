import 'package:meta/meta.dart';

@immutable
abstract class HomeBottombarVisibleState {}

class InitialHomeBottombarVisibleState extends HomeBottombarVisibleState {}

class VisibleBottombarState extends HomeBottombarVisibleState {}

class InvisibleBottombarState extends HomeBottombarVisibleState {}
