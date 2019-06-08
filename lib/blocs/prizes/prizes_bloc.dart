import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:slsywc19/models/prize.dart';
import 'package:slsywc19/models/user.dart';
import 'package:slsywc19/network/repository/ieee_data_repository.dart';
import './prizes.dart';
import 'package:slsywc19/exceptions/data_fetch_exception.dart';

class PrizesBloc extends Bloc<PrizesEvent, PrizesState> {
  final CurrentUser currentUser;
  final IEEEDataRepository dataRepository;

  PrizesBloc(this.currentUser, this.dataRepository);

  void openPrizesStream() {
    dispatch(OpenPrizesStreamEvent());
  }

  void closePrizesStream() {
    dispatch(ClosePrizesStreamEvent());
  }

  @override
  PrizesState get initialState => InitialPrizesState();

  @override
  Stream<PrizesState> mapEventToState(
    PrizesEvent event,
  ) async* {
    if (event is OpenPrizesStreamEvent) {
      yield* _openPrizesStream();
    } else if (event is ClosePrizesStreamEvent) {
      yield* _closePrizesStream();
    }
  }

  Stream<PrizesState> _openPrizesStream() async* {
    try {
      yield OpenedPrizesStreamState(
          dataRepository.streamPrizes(currentUser.id));
    } on DataFetchException catch (e) {
      print("${e.toString()}");
      yield ErrorPrizesStreamState();
    }
  }

  Stream<PrizesState> _closePrizesStream() async* {
    dataRepository.closePrizeStream();
  }
}
