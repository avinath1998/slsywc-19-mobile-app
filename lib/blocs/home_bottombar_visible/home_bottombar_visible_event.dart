import 'package:meta/meta.dart';

@immutable
abstract class HomeBottombarVisibleEvent {}

class OpenBottombarEvent extends HomeBottombarVisibleEvent {}

class CloseBottombarEvent extends HomeBottombarVisibleEvent {}
