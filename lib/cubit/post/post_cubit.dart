import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_the_world/services/firestore/posts/post_service_interface.dart';
import 'package:travel_the_world/services/models/posts/post_model.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final PostServiceInterface postService;
  PostCubit({required this.postService}) : super(PostInitial());

  Future<void> getPosts() async {
    emit(PostLoading());
    try {
      final posts = await postService.getPosts();

      if (posts.isNotEmpty) {
        emit(PostLoaded(posts: posts));
      } else {
        emit(PostEmpty());
      }
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> getPostsFiltered(String text) async {
    emit(PostLoading());
    try {
      final posts = await postService.getPostsFiltered(text);

      if (posts.isNotEmpty) {
        emit(FilteredPostsLoaded(posts: posts));
      } else {
        emit(PostEmpty());
      }
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> getPostsFromFollowingUsersInTheLast24h(UserModel user) async {
    emit(PostLoading());
    try {
      final posts = await postService.getPostsFromFollowedUsersInTheLast24h(
          currentUser: user);

      if (posts.isNotEmpty) {
        emit(PostLoaded(posts: posts));
      } else {
        emit(PostEmpty());
      }
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> likePost({required PostModel post}) async {
    try {
      await postService.likePost(postId: post.postId);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> deletePost({required String postId}) async {
    try {
      await postService.deletePost(postId: postId);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> createPost({required PostModel post}) async {
    try {
      await postService.createPost(post: post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> updatePost({required PostModel post}) async {
    try {
      await postService.updatePost(post: post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> addCategoryAndDimensions({required PostModel post}) async {
    try {
      await postService.addCategoryAndDimensions(post: post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }
}
