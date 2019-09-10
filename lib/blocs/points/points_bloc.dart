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

  void openStream() {
    dispatch(OpenPointsEvent(dataRepository.cachedPoints));
  }

  @override
  PointsState get initialState =>
      InitialPointsState(dataRepository.cachedPoints);

  @override
  Stream<PointsState> mapEventToState(
    PointsEvent event,
  ) async* {
    if (event is OpenPointsEvent) {
      yield FetchedPointsState(event.val);
    }
  }

  void openPointsStream() {
    try {
      print("Opening Points Stream");
      dataRepository.openPointsStream(currentUser.id, (val) {
        dispatch(OpenPointsEvent(val));
      });
    } on DataFetchException catch (e) {
      print("Could not stream points: ${e.msg}");
    }
  }

  @override
  void dispose() {
    super.dispose();
    print("CLOSING Points Stream");
    print("Disposing Points Bloc");
    dataRepository.closePointsStream();
  }

  Stream<PointsState> _fetchPoints() async* {
    try {
      print("Opening Stream for Points");
      yield WaitingFetchingPointsState(dataRepository.cachedPoints);
      int pointsStream = await dataRepository.fetchPoints(currentUser.id);
      yield FetchedPointsState(pointsStream);
    } on DataFetchException catch (e) {
      print("Could not stream points: ${e.msg}");
      yield PointsErrorState(e.msg);
    }
  }
}
