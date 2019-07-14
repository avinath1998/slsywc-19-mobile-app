import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:slsywc19/exceptions/data_fetch_exception.dart';
import 'package:slsywc19/models/event.dart';
import 'package:slsywc19/models/user.dart';
import 'package:slsywc19/network/repository/ieee_data_repository.dart';
import './timeline.dart';

class TimelineBloc extends Bloc<TimelineEvent, TimelineState> {
  final IEEEDataRepository dataRepository;
  final CurrentUser user;
  final String _TAG = "TimelineBloc";
  TimelineBloc(this.dataRepository, this.user);

  int currentPage = 0;
  double dayOnePos = 0;
  double dayTwoPos = 0;
  double daythreePos = 0;

  void switchDay(int day) {
    dispatch(SwitchDay(day));
  }

  @override
  TimelineState get initialState => InitialTimelineState();

  @override
  Stream<TimelineState> mapEventToState(
    TimelineEvent event,
  ) async* {
    if (event is SwitchDay) {
      yield* _switchDay(event.day);
    }
  }

  Stream<TimelineState> _switchDay(int day) async* {
    if (day == 1) {
      yield DayOneTimelineState();
    } else if (day == 2) {
      yield DayTwoTimelineState();
    } else if (day == 3) {
      yield DayThreeTimelineState();
    }
  }
}
