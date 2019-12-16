import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:slsywc19/blocs/auth/auth_event.dart';
import 'package:slsywc19/exceptions/user_not_found_exception.dart';
import 'package:slsywc19/exceptions/user_not_registered.dart';
import 'package:slsywc19/models/user.dart';
import 'package:slsywc19/network/repository/ieee_data_repository.dart';
import 'package:slsywc19/services/auth_service.dart';
import './auth.dart';
import 'package:slsywc19/blocs/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  CurrentUser currentUser;
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

  void signOut() {
    dispatch(SignOutEvent());
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
      CurrentUser temp = await authService.getCurrentUser();
      currentUser = await dataRepository.fetchUser(temp.id);
      if (currentUser != null) {
        print("$_TAG Current User has been found: ${currentUser.id}");
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
      currentUser = await authService.googleSignIn();
      print("$_TAG Current User has been found: ${currentUser.id}");
      yield SignedInState();
    } on UserNotFoundException catch (e) {
      print(
          "$_TAG User not found although they are registered: ${e.toString()}");
      yield UserNotFoundState();
    } on UserNotRegisteredException catch (e) {
      print("$_TAG User not registered: ${e.toString()}");
      yield UserNotRegisteredState();
    } catch (e) {
      print(
          "$_TAG Signing in error, authentication error state initiated: ${e.toString()}");
      yield AuthenticationErrorState(e.toString());
    }
  }

  Stream<AuthState> _signOut() async* {
    print("$_TAG Sign out event triggered");
    try {
      authService.signOut();
      yield SignedOutState();
    } catch (e) {
      print("$_TAG Signing out error: ${e.toString()}");
      yield AuthenticationErrorState(e);
    }
  }
}
