import 'package:travel_the_world/features/domain/entites/post/post_entity.dart';
import 'package:travel_the_world/features/domain/repository/firebase_repository_interface.dart';

class DeletePostUseCase {
  final FirebaseRepositoryInterface repository;

  DeletePostUseCase({required this.repository});

  Future<void> call(PostEntity post) {
    return repository.deletePost(post);
  }
}
