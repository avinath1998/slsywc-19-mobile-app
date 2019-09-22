import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import './animating_list_notifier.dart';

class AnimatingListNotifierBloc
    extends Bloc<AnimatingListNotifierEvent, AnimatingListNotifierState> {
  final ScrollController scrollController;

  AnimatingListNotifierBloc(this.scrollController);
  @override
  AnimatingListNotifierState get initialState =>
      InitialAnimatingListNotifierState();

  void initializeNotifier() {
    dispatch(InitializeNotifier());
    print("INitializer Called");
  }

  @override
  Stream<AnimatingListNotifierState> mapEventToState(
    AnimatingListNotifierEvent event,
  ) async* {
    if (event is InitializeNotifier) {
      print("SCROLL CONTROLLER: ${scrollController.hasClients}");
      scrollController.addListener(() async {
        if (scrollController.offset <= 90.0) {
          if (currentState is InitialAnimatingListNotifierState ||
              currentState is BelowTopOfListState) {
            dispatch(AtTopOfListEvent());
          }
        } else {
          if (currentState is InitialAnimatingListNotifierState ||
              currentState is AtTopOfListState) {
            dispatch(BelowTopOfListEvent());
          }
        }
      });
    } else if (event is AtTopOfListEvent) {
      yield AtTopOfListState();
    } else if (event is BelowTopOfListEvent) {
      yield BelowTopOfListState();
    }
  }
}
