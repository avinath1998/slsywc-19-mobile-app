import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class HomeBottombarVisibleBloc
    extends Bloc<HomeBottombarVisibleEvent, HomeBottombarVisibleState> {
  void hideBottomBar() {
    print("Closing Bottom Bar");
    dispatch(CloseBottombarEvent());
  }

  void showBottomBar() {
    print("Opening Bottom Bar");
    dispatch(OpenBottombarEvent());
  }

  @override
  HomeBottombarVisibleState get initialState =>
      InitialHomeBottombarVisibleState();

  @override
  Stream<HomeBottombarVisibleState> mapEventToState(
    HomeBottombarVisibleEvent event,
  ) async* {
    if (event is CloseBottombarEvent) {
      yield (InvisibleBottombarState());
    } else
      yield (VisibleBottombarState());
  }
}
