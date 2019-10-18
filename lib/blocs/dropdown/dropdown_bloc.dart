import 'dart:async';
import 'package:bloc/bloc.dart';
import './dropdown.dart';

class DropdownBloc extends Bloc<DropdownEvent, DropdownState> {
  String _currentVal;

  String get currentVal => _currentVal;

  set currentVal(String currentVal) {
    _currentVal = currentVal;
  }

  DropdownBloc(this._currentVal);

  @override
  DropdownState get initialState => InitialDropdownState(_currentVal);

  @override
  Stream<DropdownState> mapEventToState(
    DropdownEvent event,
  ) async* {
    if (event is OnChangeEvent) {
      this._currentVal = event.changedVal;
      yield (InitialDropdownState(event.changedVal));
    }
  }
}
