import 'dart:io';

import 'package:travel_the_world/features/domain/entites/reply/reply_entity.dart';

abstract class FirebaseRepositoryInterface {
  // Cloud Storage
  Future<Map<String, String>> uploadImagePost(File? file, String childName);

  // Reply Features
  Future<void> createReply(ReplyEntity reply);
  Stream<List<ReplyEntity>> readReplies(ReplyEntity reply);
  Future<void> updateReply(ReplyEntity reply);
  Future<void> deleteReply(ReplyEntity reply);
  Future<void> likeReply(ReplyEntity reply);

  // others
  Future<void> syncProfilePicture(String profileUrl);
}
