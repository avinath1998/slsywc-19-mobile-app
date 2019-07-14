import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:slsywc19/models/user.dart';
import 'package:slsywc19/network/repository/ieee_data_repository.dart';
import './points.dart';
import 'package:slsywc19/exceptions/data_fetch_exception.dart';

class PointsBloc extends Bloc<PointsEvent, PointsState> {
  CurrentUser currentUser;
  IEEEDataRepository dataRepository;
  PointsBloc(this.currentUser, this.dataRepository);

  void fetchPoints() {
    dispatch(FetchPointsEvent());
  }

  @override
  PointsState get initialState =>
      InitialPointsState(dataRepository.cachedPoints);

  @override
  Stream<PointsState> mapEventToState(
    PointsEvent event,
  ) async* {
    if (event is FetchPointsEvent) {
      yield* _openStream();
    }
  }

  Stream<PointsState> _openStream() async* {
    try {
      print("Opening Stream for Points");
      yield WaitingFetchingPointsState();
      int pointsStream = await dataRepository.fetchPoints(currentUser.id);
      yield FetchedPointsState(pointsStream);
    } on DataFetchException catch (e) {
      print("Could not stream points: ${e.msg}");
      yield PointsErrorState(e.msg);
    }
  }
}
