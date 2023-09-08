import 'package:travel_the_world/features/domain/repository/firebase_repository_interface.dart';

class UpdatePostsProfilePictureUseCase {
  final FirebaseRepositoryInterface repository;

  UpdatePostsProfilePictureUseCase({required this.repository});

  Future<void> call(String profileUrl) {
    return repository.updatePostsProfilePicture(profileUrl);
  }
}
