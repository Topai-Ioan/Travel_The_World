import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_the_world/services/firestore/user_service.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';

part 'get_single_user_state.dart';

class GetSingleUserCubit extends Cubit<GetSingleUserState> {
  GetSingleUserCubit() : super(GetSingleUserInitial());

  Future<void> getSingleUser({required String uid}) async {
    emit(GetSingleUserLoading());
    try {
      final streamResponse = UserService().getUser(uid: uid);
      streamResponse.listen((users) {
        if (users.isNotEmpty) {
          emit(GetSingleUserLoaded(user: users.first));
        }
      });
    } on SocketException catch (_) {
      emit(GetSingleUserFailure());
    } catch (_) {
      emit(GetSingleUserFailure());
    }
  }
}
