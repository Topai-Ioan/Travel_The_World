import 'package:travel_the_world/features/domain/entites/user/user_entity.dart';
import 'package:travel_the_world/features/domain/repository/firebase_repository_interface.dart';

class UserUseCases {
  final FirebaseRepositoryInterface repository;

  UserUseCases({required this.repository});

  Future<void> createUser(UserEntity user, String profileUrl) {
    return repository.createUser(user, profileUrl);
  }

  Future<String> getCurrentUid() {
    return repository.getCurrentUid();
  }

  Stream<List<UserEntity>> getSingleUser(String uid) {
    return repository.getSingleUser(uid);
  }

  Stream<List<UserEntity>> getUsers(UserEntity userEntity) {
    return repository.getUsers(userEntity);
  }

  Future<bool> isSignIn() {
    return repository.isSignIn();
  }

  Future<void> signOut() {
    return repository.signOut();
  }

  Future<void> signUpUser(UserEntity userEntity) {
    return repository.signUpUser(userEntity);
  }

  Future<void> updateUser(UserEntity userEntity) {
    return repository.updateUser(userEntity);
  }
}
