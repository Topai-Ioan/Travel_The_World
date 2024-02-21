import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:travel_the_world/services/firestore/auth/auth_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;
  AuthCubit({required this.authService}) : super(AuthInitial());

  Future<void> appStarted(BuildContext context) async {
    try {
      bool isSignIn = await AuthService().isSignIn();
      if (isSignIn) {
        final uid = authService.getCurrentUserId()!;
        emit(Authenticated(uid: uid));
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      //todo log error
      emit(UnAuthenticated());
    }
  }

  Future<void> loggedIn() async {
    try {
      final uid = authService.getCurrentUserId()!;
      emit(Authenticated(uid: uid));
    } catch (e) {
      //todo log error
      emit(UnAuthenticated());
    }
  }

  Future<void> loggedOut() async {
    //todo this can be simplified Subscription

    try {
      await AuthService().signOut();
      emit(UnAuthenticated());
    } catch (e) {
      //todo log error
      emit(UnAuthenticated());
    }
  }
}
