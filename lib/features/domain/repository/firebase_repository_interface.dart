import 'dart:io';

abstract class FirebaseRepositoryInterface {
  // Cloud Storage
  Future<Map<String, String>> uploadImagePost(File? file, String childName);

  // others
  Future<void> syncProfilePicture(String profileUrl);
}
