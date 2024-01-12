import 'package:travel_the_world/services/models/comments/comment_model.dart';

abstract class CommentServiceInterface {
  Future<void> createComment({required CommentModel comment});
  Future<void> deleteComment({required String commentId});
  Future<void> likeComment({required CommentModel comment});
  Stream<List<CommentModel>> getComments({required String postId});
  Future<CommentModel> getCommentById({required String commentId});
  Future<void> editComment({required CommentModel comment});
}
