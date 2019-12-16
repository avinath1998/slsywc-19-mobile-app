import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:slsywc19/exceptions/data_write_exception.dart';
import 'package:slsywc19/models/user.dart';
import 'package:slsywc19/network/repository/ieee_data_repository.dart';
import './registration.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final IEEEDataRepository _dataRepository;

  RegistrationBloc(this._dataRepository);

  void registerUser(CurrentUser user) {
    dispatch(RegisterUserEvent(user));
  }

  @override
  RegistrationState get initialState => InitialRegistrationState();

  @override
  Stream<RegistrationState> mapEventToState(
    RegistrationEvent event,
  ) async* {
    if (event is RegisterUserEvent) {
      yield* _registerUser(event.user);
    }
  }

  Stream<RegistrationState> _registerUser(CurrentUser user) async* {
    try {
      yield RegistrationWaitingState();
      _dataRepository.registerUser(user);
      yield RegistrationSuccessfulState();
    } on DataWriteException catch (e) {
      yield RegistrationErrorState();
    }
  }
}
