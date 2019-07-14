import 'package:meta/meta.dart';

@immutable
abstract class PrizesEvent {}

class FetchPrizesEvent extends PrizesEvent {}
