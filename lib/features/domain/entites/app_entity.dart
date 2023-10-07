import 'package:travel_the_world/services/models/posts/post_model.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';

class AppEntity {
  final UserModel? currentUser;
  final PostModel? postModel;

  final String? uid;
  final String? postId;

  AppEntity({this.currentUser, this.postModel, this.uid, this.postId});
}
