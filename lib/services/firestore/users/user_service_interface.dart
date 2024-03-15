import 'package:travel_the_world/services/models/users/user_model.dart';
import 'package:travel_the_world/services/models/users/user_model_for_lists.dart';

abstract class UserServiceInterface {
  Stream<List<UserModel>> getUser({required String uid});
  Future<void> createUser(
      {required UserModel user, required String profileUrl});
  Future<void> updateUser({required UserModel user});
  Future<String> getUserProfileUrl({required String uid});
  Future<void> followUnFollowUser({required String anoterUserId});

  Future<List<UserModel>> searchUsers(String query);
  Future<List<UserModelForLists>> getUsers({required List<String> uids});
}
