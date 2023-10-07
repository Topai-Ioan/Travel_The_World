import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_the_world/services/firestore/users/user_service.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';

part 'get_single_other_user_state.dart';

class GetSingleOtherUserCubit extends Cubit<GetSingleOtherUserState> {
  GetSingleOtherUserCubit() : super(GetSingleOtherUserInitial());

  Future<void> getSingleOtherUser({required String otherUid}) async {
    emit(GetSingleOtherUserLoading());
    try {
      final streamResponse = UserService().getUser(uid: otherUid);
      streamResponse.listen((users) {
        emit(GetSingleOtherUserLoaded(otherUser: users.first));
      });
    } on SocketException catch (_) {
      emit(GetSingleOtherUserFailure());
    } catch (_) {
      emit(GetSingleOtherUserFailure());
    }
  }
}
