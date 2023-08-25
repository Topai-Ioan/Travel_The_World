import 'package:travel_the_world/features/domain/repository/firebase_repository_interface.dart';

class GetCurrentUidUseCase {
  final FirebaseRepositoryInterface repository;

  GetCurrentUidUseCase({required this.repository});

  Future<String> call() {
    return repository.getCurrentUid();
  }
}
