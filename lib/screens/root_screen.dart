import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:slsywc19/blocs/auth/auth_bloc.dart';
import 'package:slsywc19/blocs/auth/auth_state.dart';
import 'package:slsywc19/network/repository/ieee_data_repository.dart';
import 'package:slsywc19/services/auth_service.dart';

import 'full_error_screen.dart';
import 'full_loading_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  AuthBloc _authBloc;
  String _TAG = "RootScreenState: ";

  @override
  void initState() {
    super.initState();
    _authBloc = new AuthBloc(
        IEEEDataRepository.get(),
        FirebaseAuthService(
            GoogleSignIn(
              scopes: [
                'email',
                'https://www.googleapis.com/auth/contacts.readonly',
              ],
            ),
            FirebaseAuth.instance));
    _authBloc.initialSignIn();
  }

  @override
  void dispose() {
    super.dispose();
    _authBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _authBloc,
      child: BlocBuilder(
        bloc: _authBloc,
        builder: (context, AuthState state) {
          print("$_TAG ${state.toString()}");
          if (state is SignedInState) {
            return HomeScreen();
          } else if (state is SignedOutState) {
            return LoginScreen();
          } else if (state is AuthenticationLoadingState) {
            return LoginScreen(
              isLoading: true,
            );
          } else if (state is AuthenticationErrorState) {
            return LoginScreen(
              errorMsg: state.errorMsg,
            );
          } else
            return FullLoadingScreen();
        },
      ),
    );
  }
}