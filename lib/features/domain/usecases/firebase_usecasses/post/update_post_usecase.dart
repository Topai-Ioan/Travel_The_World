import 'package:travel_the_world/features/domain/entites/post/post_entity.dart';
import 'package:travel_the_world/features/domain/repository/firebase_repository_interface.dart';

class UpdatePostUseCase {
  final FirebaseRepositoryInterface repository;

  UpdatePostUseCase({required this.repository});

  Future<void> call(PostEntity post) {
    return repository.updatePost(post);
  }
}
