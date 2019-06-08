import 'package:meta/meta.dart';

@immutable
abstract class PrizesEvent {}

class OpenPrizesStreamEvent extends PrizesEvent {}

class ClosePrizesStreamEvent extends PrizesEvent {}
