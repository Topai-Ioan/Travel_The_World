import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_the_world/services/firestore/posts/post_service_interface.dart';
import 'package:travel_the_world/services/models/posts/post_model.dart';

part 'home_page_posts_state.dart';

class HomePagePostsCubit extends Cubit<HomePagePostsState> {
  final PostServiceInterface postService;

  HomePagePostsCubit({required this.postService})
      : super(HomePagePostsInitial());

  Future<List<PostModel>> getFirstXPosts(int numberOfPosts) async {
    emit(HomePagePostsLoading());
    try {
      List<PostModel> posts = await postService.getFirstXPosts(numberOfPosts);
      if (posts.isNotEmpty) {
        emit(HomePagePostsLoaded(posts: posts));
      } else {
        emit(HomePagePostsFailure());
      }
      return posts;
    } catch (error) {
      emit(HomePagePostsEmpty());
      return [];
    }
  }

  Future<List<PostModel>> getMorePosts(
      int pageSize, DocumentSnapshot startAfter) async {
    try {
      List<PostModel> posts =
          await postService.getMorePosts(pageSize, startAfter);
      if (posts.isNotEmpty) {
        emit(HomePagePostsLoaded(posts: posts));
      } else {
        emit(HomePagePostsEmpty());
      }
      return posts;
    } catch (error) {
      emit(HomePagePostsFailure());
      return [];
    }
  }

  DocumentReference? getPostReference(String postId) {
    return postService.getPostReference(postId);
  }
}
