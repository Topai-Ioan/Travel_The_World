import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_the_world/services/firestore/users/user_service_interface.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserServiceInterface userService;

  UserCubit({required this.userService}) : super(UserInitial());

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

  void searchUsers(String query) async {
    if (query.isNotEmpty) {
      emit(UserLoading());
      try {
        final users = await userService.searchUsers(query);
        emit(UsersLoaded(users: users));
      } catch (e) {
        emit(UserFailure());
      }
    } else {
      emit(UserInitial());
    }
  }
}
