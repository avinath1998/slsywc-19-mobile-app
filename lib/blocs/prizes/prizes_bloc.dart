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

  PrizesBloc(this.currentUser, this.dataRepository) {}

  @override
  PrizesState get initialState =>
      InitialPrizesState(dataRepository.cachedPrizes);

  @override
  Stream<PrizesState> mapEventToState(
    PrizesEvent event,
  ) async* {
    if (event is PrizesUpdatedEvent) {
      yield FetchedPrizesState(event.prizes);
    }
  }

  void openPrizesStream() {
    try {
      print("OPENING Prizes Stream");
      dataRepository.openPrizesStream(currentUser.id, (e) {
        dispatch(PrizesUpdatedEvent(e));
      });
    } on DataFetchException catch (e) {
      print("${e.msg}");
    }
  }

  @override
  void dispose() {
    super.dispose();
    print("Disposing Prizes Bloc");
    dataRepository.closePrizesStream();
    print("CLOSING Prizes Stream");
  }
}
