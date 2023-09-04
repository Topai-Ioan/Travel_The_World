import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_the_world/features/domain/entites/reply/reply_entity.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/reply/create_reply_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/reply/delete_reply_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/reply/like_reply_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/reply/read_replies_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/reply/update_reply_usecase.dart';

part 'reply_state.dart';

class ReplyCubit extends Cubit<ReplyState> {
  final CreateReplyUseCase createReplyUseCase;
  final DeleteReplyUseCase deleteReplyUseCase;
  final LikeReplyUseCase likeReplyUseCase;
  final ReadRepliesUseCase readRepliesUseCase;
  final UpdateReplyUseCase updateReplyUseCase;

  ReplyCubit(
      {required this.createReplyUseCase,
      required this.updateReplyUseCase,
      required this.readRepliesUseCase,
      required this.likeReplyUseCase,
      required this.deleteReplyUseCase})
      : super(ReplyInitial());

  Future<void> getReplies({required ReplyEntity reply}) async {
    emit(ReplyLoading());
    try {
      final streamResponse = readRepliesUseCase.call(reply);
      streamResponse.listen((replies) {
        if (replies.isNotEmpty) {
          emit(ReplyLoaded(replies: replies));
        }
      });
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> likeReply({required ReplyEntity reply}) async {
    try {
      await likeReplyUseCase.call(reply);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> createReply({required ReplyEntity reply}) async {
    try {
      await createReplyUseCase.call(reply);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> deleteReply({required ReplyEntity reply}) async {
    try {
      await deleteReplyUseCase.call(reply);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> updateReply({required ReplyEntity reply}) async {
    try {
      await updateReplyUseCase.call(reply);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }
}
