import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_the_world/services/firestore/users/user_service_interface.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserServiceInterface userService;

  UserCubit({required this.userService}) : super(UserInitial());

  Future<void> getUsers({required UserModel user}) async {
    emit(UserLoading());
    try {
      final streamResponse = userService.getUsers();
      streamResponse.listen((users) {
        emit(UsersLoaded(users: users));
      });
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }

  Future<void> updateUser({required UserModel user}) async {
    try {
      userService.updateUser(user: user);
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }

  Future<void> followUnFollowUser({required UserModel user}) async {
    try {
      await userService.followUnFollowUser(anoterUserId: user.uid);
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }
}
