import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_the_world/services/firestore/posts/post_service_interface.dart';
import 'package:travel_the_world/services/models/posts/post_model.dart';

part 'get_single_post_state.dart';

class GetSinglePostCubit extends Cubit<GetSinglePostState> {
  final PostServiceInterface postService;
  GetSinglePostCubit({required this.postService})
      : super(GetSinglePostInitial());

  Future<void> getSinglePost({required String postId}) async {
    emit(GetSinglePostLoading());
    try {
      final posts = await postService.getPost(postId: postId);
      if (posts.isNotEmpty) {
        emit(GetSinglePostLoaded(post: posts.first));
      }
    } on SocketException catch (_) {
      emit(GetSinglePostFailure());
    } catch (_) {
      emit(GetSinglePostFailure());
    }
  }
}
