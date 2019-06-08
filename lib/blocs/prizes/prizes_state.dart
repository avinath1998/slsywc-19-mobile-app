import 'package:meta/meta.dart';
import 'package:slsywc19/models/prize.dart';

@immutable
abstract class PrizesState {}

class InitialPrizesState extends PrizesState {}

class OpenedPrizesStreamState extends PrizesState {
  final Stream<List<Prize>> stream;
  OpenedPrizesStreamState(this.stream);
}

class ClosedPrizesStreamState extends PrizesState {}

class ErrorPrizesStreamState extends PrizesState {}
