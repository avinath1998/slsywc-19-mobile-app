import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:slsywc19/blocs/auth/auth_event.dart';
import 'package:slsywc19/models/user.dart';
import 'package:slsywc19/network/repository/ieee_data_repository.dart';
import 'package:slsywc19/services/auth_service.dart';
import './auth.dart';
import 'package:slsywc19/blocs/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  CurrentUser _currentUser;
  final IEEEDataRepository dataRepository;
  final AuthService authService;
  String _TAG = "AuthBloc: ";

  AuthBloc(this.dataRepository, this.authService);

  void initialSignIn() {
    dispatch(InitialSignInEvent());
  }

  void signIn() {
    dispatch(SignInEvent());
  }

  @override
  AuthState get initialState => InitialAuthState();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is SignInEvent) {
      yield* _signIn();
    } else if (event is SignOutEvent) {
      yield* _signOut();
    } else if (event is InitialSignInEvent) {
      yield* _checkIfCurrentUserisAlreadySignedIn();
    }
  }

  Stream<AuthState> _checkIfCurrentUserisAlreadySignedIn() async* {
    print("$_TAG Sign in event triggered");
    try {
      _currentUser = await authService.getCurrentUser();
      if (_currentUser != null) {
        print("$_TAG Current User has been found: ${_currentUser.id}");
        yield SignedInState();
      } else {
        yield SignedOutState();
      }
    } catch (e) {
      print("$_TAG Signing in error: ${e.toString()}");
      yield SignedOutState();
    }
  }

  Stream<AuthState> _signIn() async* {
    print("$_TAG Sign in event triggered");
    try {
      yield AuthenticationLoadingState();
      _currentUser = await authService.googleSignIn();
      print("$_TAG Current User has been found: ${_currentUser.id}");
      yield SignedInState();
    } catch (e) {
      print(
          "$_TAG Signing in error, authentication error state initiated: ${e.toString()}");
      yield AuthenticationErrorState(e.toString());
    }
  }

  Stream<AuthState> _signOut() async* {
    print("$_TAG Sign out event triggered");
    try {
      await authService.signOut();
      yield SignedOutState();
    } catch (e) {
      print("$_TAG Signing out error: ${e.toString()}");
      yield AuthenticationErrorState(e);
    }
  }
}
