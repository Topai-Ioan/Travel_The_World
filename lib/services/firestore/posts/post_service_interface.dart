import 'package:travel_the_world/services/models/posts/post_model.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';

abstract class PostServiceInterface {
  Future<void> updatePost({required PostModel post});

  Stream<List<PostModel>> getPosts();
  Stream<List<PostModel>> getPost({required String postId});
  Future<void> likePost({required String postId});
  Future<void> deletePost({required String postId});
  Future<void> createPost({required PostModel post});
  Future<Stream<List<PostModel>>> getPostsFromFollowedUsers(
      {required UserModel currentUser});
}
