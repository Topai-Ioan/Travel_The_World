import 'package:travel_the_world/features/domain/repository/firebase_repository_interface.dart';

class IsSignInUseCase {
  final FirebaseRepositoryInterface repository;

  IsSignInUseCase({required this.repository});

  Future<bool> call() {
    return repository.isSignIn();
  }
}
