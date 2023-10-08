import 'dart:io';

import 'package:travel_the_world/features/data/data_sources/remote_data_source/remote_data_source_interface.dart';
import 'package:travel_the_world/features/domain/repository/firebase_repository_interface.dart';

class FirebaseRepository implements FirebaseRepositoryInterface {
  final FirebaseRemoteDataSourceInterface remoteDataSource;

  FirebaseRepository({required this.remoteDataSource});

  @override
  Future<Map<String, String>> uploadImagePost(
          File? file, String childName) async =>
      remoteDataSource.uploadImagePost(file, childName);

  @override
  Future<void> syncProfilePicture(String profileUrl) async =>
      remoteDataSource.syncProfilePicture(profileUrl);
}
