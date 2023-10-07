import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_the_world/services/firestore/posts/post_service.dart';
import 'package:travel_the_world/services/models/posts/post_model.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostInitial());
  final PostService _postService = PostService();

  Future<void> getPosts() async {
    emit(PostLoading());
    try {
      final streamResponse = _postService.getPosts();

      final subscription = streamResponse.listen((posts) {
        if (posts.isNotEmpty) {
          emit(PostLoaded(posts: posts));
        } else {
          emit(PostEmpty());
        }
      });
      subscription.resume();
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> getPostsFromFollowingUsers(UserModel user) async {
    emit(PostLoading());
    try {
      final streamResponse =
          await _postService.getPostsFromFollowedUsers(currentUser: user);

      final subscription = streamResponse.listen((posts) {
        if (posts.isNotEmpty) {
          emit(PostLoaded(posts: posts));
        } else {
          emit(PostEmpty());
        }
      });
      subscription.resume();
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> likePost({required PostModel post}) async {
    try {
      await _postService.likePost(post: post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> deletePost({required PostModel post}) async {
    try {
      await _postService.deletePost(post: post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> createPost({required PostModel post}) async {
    try {
      await _postService.createPost(post: post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> updatePost({required PostModel post}) async {
    try {
      await _postService.updatePost(post: post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }
}
