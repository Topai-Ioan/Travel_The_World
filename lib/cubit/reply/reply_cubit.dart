import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_the_world/services/firestore/replies/reply_service.dart';
import 'package:travel_the_world/services/models/replies/reply_model.dart';

part 'reply_state.dart';

class ReplyCubit extends Cubit<ReplyState> {
  final ReplyService replyService = ReplyService();
  ReplyCubit() : super(ReplyInitial());

  Future<void> getReplies({required ReplyModel reply}) async {
    emit(ReplyLoading());
    try {
      final streamResponse = replyService.getReplies(reply.commentId);
      streamResponse.listen((replies) {
        emit(ReplyLoaded(replies: replies));
      });
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> likeReply({required ReplyModel reply}) async {
    try {
      await replyService.likeReply(reply);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> createReply({required ReplyModel reply}) async {
    try {
      await replyService.createReply(reply);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> deleteReply({required ReplyModel reply}) async {
    try {
      await replyService.deleteReply(reply);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> updateReply({required ReplyModel reply}) async {
    try {
      await replyService.updateReply(reply);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }
}
