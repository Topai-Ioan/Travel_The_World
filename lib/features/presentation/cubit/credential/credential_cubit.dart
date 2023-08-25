import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_the_world/features/domain/entites/user/user_entity.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/user/sign_in_user_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/user/sign_up_user_usecase.dart';

part 'credential_state.dart';

class CredentialCubit extends Cubit<CredentialState> {
  final SignInUserUseCase signInUserUseCase;
  final SignUpUseCase signUpUseCase;
  CredentialCubit(
      {required this.signInUserUseCase, required this.signUpUseCase})
      : super(CredentialInitial());

  Future<void> signInUser({
    required String email,
    required String password,
  }) async {
    _performAuthentication(() async {
      await signInUserUseCase
          .call(UserEntity(email: email, password: password));
    });
  }

  Future<void> signUpUser({required UserEntity user}) async {
    _performAuthentication(() async {
      await signUpUseCase.call(user);
    });
  }

  // todo log different exceptions
  Future<void> _performAuthentication(Function authenticationAction) async {
    emit(CredentialLoading());
    try {
      await authenticationAction();
      emit(CredentialSuccess());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }
}
