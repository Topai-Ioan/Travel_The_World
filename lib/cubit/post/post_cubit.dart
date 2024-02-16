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

  void getPosts() {
    emit(PostLoading());
    postService.getPosts().listen(
      (posts) {
        if (posts.isNotEmpty) {
          emit(PostLoaded(posts: posts));
        } else {
          emit(PostEmpty());
        }
      },
      onError: (error) {
        emit(PostFailure());
      },
    );
  }

  void getPostsFiltered(String text) {
    emit(PostLoading());
    postService.getPostsFiltered(text).listen(
      (posts) {
        if (posts.isNotEmpty) {
          emit(FilteredPostsLoaded(posts: posts));
        } else {
          emit(PostEmpty());
        }
      },
      onError: (error) {
        emit(PostFailure());
      },
    );
  }

  void getPostsFromFollowingUsersInTheLast24h(UserModel user) {
    emit(PostLoading());
    postService.getPostsFromFollowedUsersInTheLast24h(currentUser: user).listen(
      (posts) {
        if (posts.isNotEmpty) {
          emit(PostLoadedInTheLast24h(posts: posts));
        } else {
          emit(PostEmpty());
        }
      },
      onError: (error) {
        emit(PostFailure());
      },
    );
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
