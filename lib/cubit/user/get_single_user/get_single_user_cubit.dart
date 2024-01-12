import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_the_world/services/firestore/users/user_service_interface.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';

part 'get_single_user_state.dart';

class GetSingleUserCubit extends Cubit<GetSingleUserState> {
  final UserServiceInterface userService;

  GetSingleUserCubit({required this.userService})
      : super(GetSingleUserInitial());

  Future<void> getSingleUser({required String uid}) async {
    emit(GetSingleUserLoading());
    try {
      final streamResponse = userService.getUser(uid: uid);
      streamResponse.listen((user) {
        if (user.isNotEmpty) {
          emit(GetSingleUserLoaded(user: user.first));
        }
      });
    } on SocketException catch (_) {
      emit(GetSingleUserFailure());
    } catch (_) {
      emit(GetSingleUserFailure());
    }
  }
}
