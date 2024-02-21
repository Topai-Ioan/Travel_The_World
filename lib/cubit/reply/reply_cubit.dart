import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_the_world/services/firestore/replies/reply_service_interface.dart';
import 'package:travel_the_world/services/models/replies/reply_model.dart';

part 'reply_state.dart';

class ReplyCubit extends Cubit<ReplyState> {
  final ReplyServiceInterface replyService;
  StreamSubscription? _replySubscription;
  ReplyCubit({required this.replyService}) : super(ReplyInitial());

  Future<void> getReplies({required ReplyModel reply}) async {
    emit(ReplyLoading());
    try {
      _replySubscription =
          replyService.getReplies(commentId: reply.commentId).listen((replies) {
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
      await replyService.likeReply(reply: reply);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> createReply({required ReplyModel reply}) async {
    try {
      await replyService.createReply(reply: reply);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> deleteReply({required ReplyModel reply}) async {
    try {
      await replyService.deleteReply(reply: reply);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> updateReply({required ReplyModel reply}) async {
    try {
      await replyService.updateReply(reply: reply);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> cancelSubscription() async {
    await _replySubscription?.cancel();
  }
}
