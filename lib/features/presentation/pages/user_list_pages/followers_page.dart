import 'package:flutter/material.dart';
import 'package:travel_the_world/features/presentation/pages/user_list_pages/user_list_helper.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';

class FollowersPage extends StatelessWidget {
  final UserModel user;
  const FollowersPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String title = "Followers";

    return FollowersPageHelper(
      user: user,
      title: title,
    );
  }
}
