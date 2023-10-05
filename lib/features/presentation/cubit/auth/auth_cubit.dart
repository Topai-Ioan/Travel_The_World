import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/user/is_sign_in_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/user/sign_out_usecase.dart';
import 'package:travel_the_world/services/auth_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignOutUseCase signOutUseCase;
  final IsSignInUseCase isSignInUseCase;
  final _authService = AuthService();
  AuthCubit({
    required this.signOutUseCase,
    required this.isSignInUseCase,
  }) : super(AuthInitial());

  Future<void> appStarted(BuildContext context) async {
    try {
      bool isSignIn = await isSignInUseCase.call();
      if (isSignIn) {
        final uid = _authService.currentUserId!;
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
      final uid = _authService.currentUserId!;
      emit(Authenticated(uid: uid));
    } catch (e) {
      //todo log error
      emit(UnAuthenticated());
    }
  }

  Future<void> loggedOut() async {
    //todo this can be simplified
    try {
      await signOutUseCase.call();
      emit(UnAuthenticated());
    } catch (e) {
      //todo log error
      emit(UnAuthenticated());
    }
  }
}
