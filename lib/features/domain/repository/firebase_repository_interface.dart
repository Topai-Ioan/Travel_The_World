import 'dart:io';

import 'package:travel_the_world/features/domain/entites/user/user_entity.dart';

abstract class FirebaseRepositoryInterface {
  // Credential Features
  Future<void> signInUser(UserEntity user);
  Future<void> signUpUser(UserEntity user);
  Future<bool> isSignIn();
  Future<void> signOut();

  // User Features
  Stream<List<UserEntity>> getUsers(UserEntity user);
  Stream<List<UserEntity>> getSingleUser(String uid);
  Future<String> getCurrentUid();
  Future<void> createUser(UserEntity user, String profileUrl);
  Future<void> updateUser(UserEntity user);

  // Cloud Storage
  Future<String> uploadImage(File? file, String childName,
      {bool isPost = true});
}
