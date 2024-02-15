import 'package:travel_the_world/services/models/posts/post_model.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';

abstract class PostServiceInterface {
  Future<void> updatePost({required PostModel post});
  Future<void> addCategoryAndDimensions({required PostModel post});

  Future<List<PostModel>> getPosts();
  Future<List<PostModel>> getPostsFiltered(String text);
  Future<List<PostModel>> getPost({required String postId});
  Future<void> likePost({required String postId});
  Future<void> deletePost({required String postId});
  Future<void> createPost({required PostModel post});
  Future<List<PostModel>> getPostsFromFollowedUsersInTheLast24h(
      {required UserModel currentUser});
}
