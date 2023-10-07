import 'dart:io';

import 'package:travel_the_world/features/domain/entites/comment/comment_entity.dart';
import 'package:travel_the_world/features/domain/entites/reply/reply_entity.dart';

abstract class FirebaseRepositoryInterface {
  // Cloud Storage
  Future<Map<String, String>> uploadImagePost(File? file, String childName);

  // Comment Features
  Future<void> createComment(CommentEntity comment);
  Stream<List<CommentEntity>> readComments(String postId);
  Future<void> updateComment(CommentEntity comment);
  Future<void> deleteComment(CommentEntity comment);
  Future<void> likeComment(CommentEntity comment);

  // Reply Features
  Future<void> createReply(ReplyEntity reply);
  Stream<List<ReplyEntity>> readReplies(ReplyEntity reply);
  Future<void> updateReply(ReplyEntity reply);
  Future<void> deleteReply(ReplyEntity reply);
  Future<void> likeReply(ReplyEntity reply);

  // others
  Future<void> syncProfilePicture(String profileUrl);
}
