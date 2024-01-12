import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_the_world/services/firestore/comments/comment_service_interface.dart';
import 'package:travel_the_world/services/models/comments/comment_model.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  final CommentServiceInterface commentService;
  CommentCubit({required this.commentService}) : super(CommentInitial());

  Future<void> getComments({required String postId}) async {
    emit(CommentLoading());
    try {
      final streamResponse = commentService.getComments(postId: postId);
      streamResponse.listen((comments) {
        emit(CommentLoaded(comments: comments));
      });
    } on SocketException catch (_) {
      emit(CommentFailure());
    } catch (_) {
      emit(CommentFailure());
    }
  }

  Future<void> likeComment({required CommentModel comment}) async {
    try {
      await commentService.likeComment(comment: comment);
    } on SocketException catch (_) {
      emit(CommentFailure());
    } catch (_) {
      emit(CommentFailure());
    }
  }

  Future<void> deleteComment({required CommentModel comment}) async {
    try {
      await commentService.deleteComment(commentId: comment.commentId);
    } on SocketException catch (_) {
      emit(CommentFailure());
    } catch (_) {
      emit(CommentFailure());
    }
  }

  Future<void> createComment({required CommentModel comment}) async {
    try {
      await commentService.createComment(comment: comment);
    } on SocketException catch (_) {
      emit(CommentFailure());
    } catch (_) {
      emit(CommentFailure());
    }
  }

  Future<void> updateComment({required CommentModel comment}) async {
    try {
      await commentService.editComment(comment: comment);
    } on SocketException catch (_) {
      emit(CommentFailure());
    } catch (_) {
      emit(CommentFailure());
    }
  }
}
