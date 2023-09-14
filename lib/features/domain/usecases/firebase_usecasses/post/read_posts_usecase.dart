import 'package:travel_the_world/features/domain/entites/post/post_entity.dart';
import 'package:travel_the_world/features/domain/repository/firebase_repository_interface.dart';

class ReadPostsUseCase {
  final FirebaseRepositoryInterface repository;

  ReadPostsUseCase({required this.repository});

  Stream<List<PostEntity>> call() {
    return repository.readPosts();
  }
}
