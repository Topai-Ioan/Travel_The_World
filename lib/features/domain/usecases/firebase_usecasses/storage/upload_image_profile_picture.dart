import 'dart:io';

import 'package:travel_the_world/features/domain/repository/firebase_repository_interface.dart';

class UploadImageProfilePictureUseCase {
  final FirebaseRepositoryInterface repository;

  UploadImageProfilePictureUseCase({required this.repository});

  Future<String> call(File? file, String childName) {
    return repository.uploadImageProfilePicture(file, childName);
  }
}
