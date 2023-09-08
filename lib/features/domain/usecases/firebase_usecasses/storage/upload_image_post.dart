import 'dart:io';

import 'package:travel_the_world/features/domain/repository/firebase_repository_interface.dart';

class UploadImagePostUseCase {
  final FirebaseRepositoryInterface repository;

  UploadImagePostUseCase({required this.repository});

  Future<Map<String, String>> call(File? file, String childName) {
    return repository.uploadImagePost(file, childName);
  }
}
