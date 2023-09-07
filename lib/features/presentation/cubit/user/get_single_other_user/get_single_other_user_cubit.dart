import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_the_world/features/domain/entites/user/user_entity.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/user/get_single_other_user_usecase.dart';

part 'get_single_other_user_state.dart';

class GetSingleOtherUserCubit extends Cubit<GetSingleOtherUserState> {
  final GetSingleOtherUserUseCase getSingleOtherUserUseCase;
  GetSingleOtherUserCubit({required this.getSingleOtherUserUseCase})
      : super(GetSingleOtherUserInitial());

  Future<void> getSingleOtherUser({required String otherUid}) async {
    emit(GetSingleOtherUserLoading());
    try {
      final streamResponse = getSingleOtherUserUseCase.call(otherUid);
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
