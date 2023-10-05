import 'package:travel_the_world/features/domain/entites/user/user_entity.dart';
import 'package:travel_the_world/features/domain/repository/firebase_repository_interface.dart';

class UserUseCases {
  final FirebaseRepositoryInterface repository;

  UserUseCases({required this.repository});

  Future<bool> isSignIn() {
    return repository.isSignIn();
  }

  Future<void> signOut() {
    return repository.signOut();
  }

  Future<void> signUpUser(UserEntity userEntity) {
    return repository.signUpUser(userEntity);
  }
}
