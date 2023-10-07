import 'dart:io';

import 'package:travel_the_world/features/data/data_sources/remote_data_source/remote_data_source_interface.dart';
import 'package:travel_the_world/features/domain/entites/comment/comment_entity.dart';
import 'package:travel_the_world/features/domain/entites/post/post_entity.dart';
import 'package:travel_the_world/features/domain/entites/reply/reply_entity.dart';
import 'package:travel_the_world/features/domain/entites/user/user_entity.dart';
import 'package:travel_the_world/features/domain/repository/firebase_repository_interface.dart';

class FirebaseRepository implements FirebaseRepositoryInterface {
  final FirebaseRemoteDataSourceInterface remoteDataSource;

  FirebaseRepository({required this.remoteDataSource});

  // @override
  // Future<bool> isSignIn() async => remoteDataSource.isSignIn();

  // @override
  // Future<void> signInUser(UserEntity user) async =>
  //     remoteDataSource.signInUser(user);

  // @override
  // Future<void> signOut() async => remoteDataSource.signOut();

  // @override
  // Future<void> signUpUser(UserEntity user) async =>
  //     remoteDataSource.signUpUser(user);

  @override
  Future<Map<String, String>> uploadImagePost(
          File? file, String childName) async =>
      remoteDataSource.uploadImagePost(file, childName);

  // @override
  // Future<String> uploadImageProfilePicture(
  //         File? file, String childName) async =>
  //     remoteDataSource.uploadImageProfilePicture(file, childName);

// todo separate files
  @override
  Future<void> createPost(PostEntity post) async =>
      remoteDataSource.createPost(post);

  @override
  Future<void> deletePost(PostEntity post) async =>
      remoteDataSource.deletePost(post);

  @override
  Future<void> likePost(PostEntity post) async =>
      remoteDataSource.likePost(post);

  @override
  Stream<List<PostEntity>> readPosts() => remoteDataSource.readPosts();

  @override
  Stream<List<PostEntity>> readSinglePost(String postId) =>
      remoteDataSource.readSinglePost(postId);
  @override
  Future<Stream<List<PostEntity>>> readPostsFromFollowedUsers(
          UserEntity currentUser) =>
      remoteDataSource.readPostsFromFollowedUsers(currentUser);

  @override
  Future<void> updatePost(PostEntity post) async =>
      remoteDataSource.updatePost(post);

  @override
  Future<void> syncProfilePicture(String profileUrl) async =>
      remoteDataSource.syncProfilePicture(profileUrl);

  @override
  Future<void> createComment(CommentEntity comment) async =>
      remoteDataSource.createComment(comment);

  @override
  Future<void> deleteComment(CommentEntity comment) async =>
      remoteDataSource.deleteComment(comment);

  @override
  Future<void> likeComment(CommentEntity comment) async =>
      remoteDataSource.likeComment(comment);

  @override
  Stream<List<CommentEntity>> readComments(String postId) =>
      remoteDataSource.readComments(postId);

  @override
  Future<void> updateComment(CommentEntity comment) async =>
      remoteDataSource.updateComment(comment);

  @override
  Future<void> createReply(ReplyEntity reply) async =>
      remoteDataSource.createReply(reply);

  @override
  Future<void> deleteReply(ReplyEntity reply) async =>
      remoteDataSource.deleteReply(reply);

  @override
  Future<void> likeReply(ReplyEntity reply) async =>
      remoteDataSource.likeReply(reply);

  @override
  Stream<List<ReplyEntity>> readReplies(ReplyEntity reply) =>
      remoteDataSource.readReplies(reply);

  @override
  Future<void> updateReply(ReplyEntity reply) async =>
      remoteDataSource.updateReply(reply);
}
