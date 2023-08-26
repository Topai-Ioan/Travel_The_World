import 'package:travel_the_world/features/domain/repository/firebase_repository_interface.dart';
import 'package:travel_the_world/features/domain/entites/post/post_entity.dart';

class CreatePostUseCase {
  final FirebaseRepositoryInterface repository;

  CreatePostUseCase({required this.repository});

  Future<void> call(PostEntity post) {
    return repository.createPost(post);
  }
}
