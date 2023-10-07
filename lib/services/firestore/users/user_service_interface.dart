import 'package:travel_the_world/services/models/users/user_model.dart';

abstract class UserServiceInterface {
  Stream<List<UserModel>> getUser({required String uid});

  Stream<List<UserModel>> getUsers();

  Future<void> createUser(
      {required UserModel user, required String profileUrl});
  Future<void> updateUser({required UserModel user});
  Future<String> getUserProfileUrl({required String uid});
  Future<void> followUnFollowUser({required String anoterUserId});
}
