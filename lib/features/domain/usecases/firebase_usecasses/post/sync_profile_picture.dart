import 'package:travel_the_world/features/domain/repository/firebase_repository_interface.dart';

class SyncProfilePictureUseCase {
  final FirebaseRepositoryInterface repository;

  SyncProfilePictureUseCase({required this.repository});

  Future<void> call(String profileUrl) {
    return repository.syncProfilePicture(profileUrl);
  }
}
