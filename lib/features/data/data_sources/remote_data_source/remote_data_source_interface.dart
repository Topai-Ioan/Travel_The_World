import 'dart:io';

import 'package:travel_the_world/features/domain/entites/comment/comment_entity.dart';
import 'package:travel_the_world/features/domain/entites/post/post_entity.dart';
import 'package:travel_the_world/features/domain/entites/reply/reply_entity.dart';
import 'package:travel_the_world/features/domain/entites/user/user_entity.dart';

abstract class FirebaseRemoteDataSourceInterface {
  // Credential Features
  Future<void> signInUser(UserEntity user);
  Future<void> signUpUser(UserEntity user);
  Future<bool> isSignIn();
  Future<void> signOut();

  // User Features
  Stream<List<UserEntity>> getUsers(UserEntity user);
  Stream<List<UserEntity>> getSingleUser(String uid);
  Future<String> getCurrentUid();
  Future<void> createUser(UserEntity user, String profileUrl);
  Future<void> updateUser(UserEntity user);

  // Cloud Storage
  Future<String> uploadImage(File? file, String childName,
      {bool isPost = true});

  // Post Features
  Future<void> createPost(PostEntity post);
  Stream<List<PostEntity>> readPosts(PostEntity post);
  Stream<List<PostEntity>> readSinglePost(String postId);
  Future<void> updatePost(PostEntity post);
  Future<void> deletePost(PostEntity post);
  Future<void> likePost(PostEntity post);

// Comment Features
  Future<void> createComment(CommentEntity comment);
  Stream<List<CommentEntity>> readComments(String postId);
  Future<void> updateComment(CommentEntity comment);
  Future<void> deleteComment(CommentEntity comment);
  Future<void> likeComment(CommentEntity comment);

  // Replay Features
  Future<void> createReply(ReplyEntity replay);
  Stream<List<ReplyEntity>> readReplies(ReplyEntity replay);
  Future<void> updateReply(ReplyEntity replay);
  Future<void> deleteReply(ReplyEntity replay);
  Future<void> likeReply(ReplyEntity replay);
}
