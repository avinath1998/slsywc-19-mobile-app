import 'package:meta/meta.dart';

@immutable
abstract class AnimatingListNotifierEvent {}

class InitializeNotifier extends AnimatingListNotifierEvent {}

class AtTopOfListEvent extends AnimatingListNotifierEvent {}

class BelowTopOfListEvent extends AnimatingListNotifierEvent {}
