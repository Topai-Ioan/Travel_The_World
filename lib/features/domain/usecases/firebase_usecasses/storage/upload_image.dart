import 'dart:io';

import 'package:travel_the_world/features/domain/repository/firebase_repository_interface.dart';

class UploadImageUseCase {
  final FirebaseRepositoryInterface repository;

  UploadImageUseCase({required this.repository});

  Future<String> call(File? file, String childName,
      {bool isPost = true, String profileUrl = ""}) {
    return repository.uploadImage(file, childName,
        isPost: isPost, profileUrl: profileUrl);
  }
}
