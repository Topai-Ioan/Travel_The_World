import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_the_world/features/domain/entites/post/post_entity.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/post/create_post_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/post/delete_post_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/post/like_post_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/post/read_posts_from_following_users_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/post/read_posts_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/post/update_post_usecase.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final CreatePostUseCase createPostUseCase;
  final DeletePostUseCase deletePostUseCase;
  final LikePostUseCase likePostUseCase;
  final ReadPostsUseCase readPostUseCase;
  ReadPostsFromFollowingUsersUseCase readPostsFromFollowingUsersUseCase;
  final UpdatePostUseCase updatePostUseCase;
  PostCubit(
      {required this.updatePostUseCase,
      required this.deletePostUseCase,
      required this.likePostUseCase,
      required this.createPostUseCase,
      required this.readPostUseCase,
      required this.readPostsFromFollowingUsersUseCase})
      : super(PostInitial());

  Future<void> getPosts() async {
    emit(PostLoading());
    try {
      final streamResponse = readPostUseCase.call();

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

  // Future<void> getPostsFromFollowingUsers(UserModel user) async {
  //   emit(PostLoading());
  //   try {
  //     final streamResponse =
  //         await readPostsFromFollowingUsersUseCase.call(user);

  //     final subscription = streamResponse.listen((posts) {
  //       if (posts.isNotEmpty) {
  //         emit(PostLoaded(posts: posts));
  //       } else {
  //         emit(PostEmpty());
  //       }
  //     });
  //     subscription.resume();
  //   } on SocketException catch (_) {
  //     emit(PostFailure());
  //   } catch (_) {
  //     emit(PostFailure());
  //   }
  // }

  Future<void> likePost({required PostEntity post}) async {
    try {
      await likePostUseCase.call(post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> deletePost({required PostEntity post}) async {
    try {
      await deletePostUseCase.call(post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> createPost({required PostEntity post}) async {
    try {
      await createPostUseCase.call(post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> updatePost({required PostEntity post}) async {
    try {
      await updatePostUseCase.call(post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }
}
