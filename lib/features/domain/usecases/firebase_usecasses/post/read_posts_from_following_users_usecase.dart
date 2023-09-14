import 'package:travel_the_world/features/domain/entites/post/post_entity.dart';
import 'package:travel_the_world/features/domain/entites/user/user_entity.dart';
import 'package:travel_the_world/features/domain/repository/firebase_repository_interface.dart';

class ReadPostsFromFollowingUsersUseCase {
  final FirebaseRepositoryInterface repository;

  ReadPostsFromFollowingUsersUseCase({required this.repository});

  Future<Stream<List<PostEntity>>> call(UserEntity user) {
    return repository.readPostsFromFollowedUsers(user);
  }
}
