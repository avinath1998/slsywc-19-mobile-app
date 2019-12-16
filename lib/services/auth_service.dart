import 'package:flutter/material.dart';
import 'package:slsywc19/exceptions/user_not_found_exception.dart';
import 'package:slsywc19/exceptions/user_not_registered.dart';
import 'package:slsywc19/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:slsywc19/network/repository/ieee_data_repository.dart';

abstract class AuthService {
  Future<CurrentUser> googleSignIn();
  Future<CurrentUser> getCurrentUser();

  void signOut();
}

class FirebaseAuthService extends AuthService {
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _auth;
  final String _TAG = "FirebaseAuthService: ";

  FirebaseAuthService(this._googleSignIn, this._auth);

  Future<CurrentUser> googleSignIn() async {
    print("$_TAG --> Signing In");

    GoogleSignInAccount googleUser;
    try {
      googleUser = await _googleSignIn.signIn();
    } catch (e) {
      print("ERROR OF SIGN IN: $e");
    }
    if (googleUser == null) {
      print("$_TAG FAILED getting Google User");
    }
    print("$_TAG  User Fetched: " + googleUser.email);
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    final FirebaseUser user = await _auth.signInWithCredential(credential);
    print("$_TAG Firebase Fetched: " + user.email);
    print("$_TAG<-- Signing In");

    if (await IEEEDataRepository.get().isRegistered(user.email)) {
      CurrentUser currentUser =
          await IEEEDataRepository.get().fetchUser(user.uid);
      if (currentUser == null) {
        await signOut();
        throw UserNotFoundException("User is registered but not found");
      }
      print(
          "$_TAG current user has been fetched from DB: ${currentUser.displayName}");
      return currentUser;
    } else {
      await signOut();
      throw UserNotRegisteredException("The user is not registered");
    }
  }

  Future<CurrentUser> getCurrentUser() async {
    print("$_TAG --> Getting Current User ");
    final FirebaseUser user = await _auth.currentUser();
    if (user == null) {
      print("$_TAG Current user not found");
      return null;
    } else {
      print("$_TAG Current user is found");
    }
    print("$_TAG <-- Current User Retrieved");

    CurrentUser currentUser = CurrentUser.fromFirebaseUser(user);
    return currentUser;
  }

  Future<void> signOut() async {
    print("$_TAG--> Signing out");
    await _googleSignIn.signOut();
    await _auth.signOut();
    print("$_TAG <-- Signing out");
  }
}
