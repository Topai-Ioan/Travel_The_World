import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_the_world/services/firestore/posts/post_service_interface.dart';
import 'package:travel_the_world/services/models/posts/post_model.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final PostServiceInterface postService;
  final List<StreamSubscription> _postSubscriptions = [];
  PostCubit({required this.postService}) : super(PostInitial());

  void getPosts() {
    emit(PostLoading());
    _postSubscriptions.add(postService.getPosts().listen(
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
    ));
  }

  void getPostsFiltered(String text) {
    emit(PostLoading());
    _postSubscriptions.add(
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
      ),
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

  Future<void> cancelSubscriptions() async {
    for (var subscription in _postSubscriptions) {
      await subscription.cancel();
    }
    _postSubscriptions.clear();
  }

  Future<List<PostModel>> getMorePosts(
      int pageSize, DocumentSnapshot startAfter) async {
    try {
      List<PostModel> posts =
          await postService.getMorePosts(pageSize, startAfter);
      if (posts.isNotEmpty) {
        emit(PostLoaded(posts: posts));
      } else {
        emit(PostEmpty());
      }
      return posts;
    } catch (error) {
      emit(PostFailure());
      return [];
    }
  }

  DocumentReference? getPostReference(String postId) {
    return postService.getPostReference(postId);
  }

  Future<List<PostModel>> getFirstXPosts(int numberOfPosts) async {
    emit(PostLoading());
    try {
      List<PostModel> posts = await postService.getFirstXPosts(numberOfPosts);
      if (posts.isNotEmpty) {
        emit(PostLoaded(posts: posts));
      } else {
        emit(PostEmpty());
      }
      return posts;
    } catch (error) {
      emit(PostFailure());
      return [];
    }
  }

  Future<List<PostModel>> getFirstXPostsFromUser(
      int numberOfPosts, String uid) async {
    emit(PostLoading());
    try {
      List<PostModel> posts =
          await postService.getFirstXPostsFromUser(numberOfPosts, uid);
      if (posts.isNotEmpty) {
        emit(PostLoaded(posts: posts));
      } else {
        emit(PostEmpty());
      }
      return posts;
    } catch (error) {
      emit(PostFailure());
      return [];
    }
  }
}
