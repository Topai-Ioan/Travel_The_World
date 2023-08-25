import 'package:travel_the_world/features/domain/repository/firebase_repository_interface.dart';

class SignOutUseCase {
  final FirebaseRepositoryInterface repository;

  SignOutUseCase({required this.repository});

  Future<void> call() {
    return repository.signOut();
  }
}
