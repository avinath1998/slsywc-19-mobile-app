import 'package:meta/meta.dart';
import 'package:slsywc19/models/prize.dart';

@immutable
abstract class PrizesEvent {}

class PrizesUpdatedEvent extends PrizesEvent {
  final List<Prize> prizes;

  PrizesUpdatedEvent(this.prizes);
}
