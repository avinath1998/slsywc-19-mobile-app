import 'dart:async';

import 'package:meta/meta.dart';
import 'package:slsywc19/models/prize.dart';

@immutable
abstract class PrizesState {}

class InitialPrizesState extends PrizesState {
  final List<Prize> cachedPrizes;
  InitialPrizesState(this.cachedPrizes);
}

class FetchedPrizesState extends PrizesState {
  final List<Prize> prizes;
  FetchedPrizesState(this.prizes);
}

class WaitingPrizesState extends PrizesState {}

class ErrorPrizesState extends PrizesState {}
