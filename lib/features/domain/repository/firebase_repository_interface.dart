import 'dart:io';

import 'package:travel_the_world/features/domain/entites/comment/comment_entity.dart';
import 'package:travel_the_world/features/domain/entites/post/post_entity.dart';
import 'package:travel_the_world/features/domain/entites/reply/reply_entity.dart';
import 'package:travel_the_world/features/domain/entites/user/user_entity.dart';

abstract class FirebaseRepositoryInterface {
  // Credential Features
  Future<void> signInUser(UserEntity user);
  Future<void> signUpUser(UserEntity user);
  Future<bool> isSignIn();
  Future<void> signOut();

  // User Features
  Stream<List<UserEntity>> getUsers(UserEntity user);
  Stream<List<UserEntity>> getSingleUser(String uid);
  Stream<List<UserEntity>> getSingleOtherUser(String otherUid);
  Future<String> getCurrentUid();
  Future<void> createUser(UserEntity user, String profileUrl);
  Future<void> updateUser(UserEntity user);
  Future<void> followUnFollowUser(UserEntity user);

  // Cloud Storage
  Future<Map<String, String>> uploadImagePost(File? file, String childName);
  Future<String> uploadImageProfilePicture(File? file, String childName);

  // Post Features
  Future<void> createPost(PostEntity post);
  Stream<List<PostEntity>> readPosts();
  Stream<List<PostEntity>> readSinglePost(String postId);
  Future<Stream<List<PostEntity>>> readPostsFromFollowedUsers(
      UserEntity currentUser);
  Future<void> updatePost(PostEntity post);
  Future<void> deletePost(PostEntity post);
  Future<void> likePost(PostEntity post);

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
