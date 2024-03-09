import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_the_world/services/models/posts/post_model.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';

abstract class PostServiceInterface {
  Future<void> updatePost({required PostModel post});
  Future<void> addCategoryAndDimensions({required PostModel post});

  Stream<List<PostModel>> getPosts();
  Stream<List<PostModel>> getPostsFiltered(String text);
  Stream<List<PostModel>> getPost({required String postId});
  Future<void> likePost({required String postId});
  Future<void> deletePost({required String postId});
  Future<void> createPost({required PostModel post});
  Stream<List<PostModel>> getPostsFromFollowedUsersInTheLast24h(
      {required UserModel currentUser});

  Future<List<PostModel>> getMorePosts(
      int pageSize, DocumentSnapshot startAfter);

  DocumentReference? getPostReference(String postId);

  Future<List<PostModel>> getFirstXPosts(int numberOfPosts);

  Future<List<PostModel>> getFirstXPostsFromUser(int numberOfPosts, String uid);
}
