import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:slsywc19/models/user.dart';
import 'package:slsywc19/network/repository/ieee_data_repository.dart';
import './realtime_notifier.dart';

class RealtimeNotifierBloc
    extends Bloc<RealtimeNotifierEvent, RealtimeNotifierState> {
  final CurrentUser currentUser;
  final IEEEDataRepository dataRepository;

  RealtimeNotifierBloc(this.currentUser, this.dataRepository);

  @override
  RealtimeNotifierState get initialState => InitialRealtimeNotifierState();

  @override
  Stream<RealtimeNotifierState> mapEventToState(
    RealtimeNotifierEvent event,
  ) async* {
    // TODO: Add Logic
  }
}
