import 'package:meta/meta.dart';

@immutable
abstract class AnimatingListNotifierState {}

class InitialAnimatingListNotifierState extends AnimatingListNotifierState {}

class AtTopOfListState extends AnimatingListNotifierState {}

class BelowTopOfListState extends AnimatingListNotifierState {}
