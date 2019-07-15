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

  void fetchPrizes() {
    dispatch(FetchPrizesEvent());
  }

  @override
  PrizesState get initialState =>
      InitialPrizesState(dataRepository.cachedPrizes);

  @override
  Stream<PrizesState> mapEventToState(
    PrizesEvent event,
  ) async* {
    if (event is FetchPrizesEvent) {
      yield* _fetchPrizes();
    }
  }

  Stream<PrizesState> _fetchPrizes() async* {
    try {
      List<Prize> prizes = await dataRepository.fetchPrizes(currentUser.id);
      yield FetchedPrizesState(prizes);
    } on DataFetchException catch (e) {
      print("${e.msg}");
      yield ErrorPrizesState();
    }
  }
}
