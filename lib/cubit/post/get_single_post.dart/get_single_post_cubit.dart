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
    postService.getPost(postId: postId).listen(
      (posts) {
        emit(GetSinglePostLoaded(post: posts.first));
      },
      onError: (error) {
        emit(GetSinglePostFailure());
      },
    );
  }
}
