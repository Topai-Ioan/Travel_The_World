import 'package:flutter/material.dart';
import 'package:travel_the_world/UI/user_list_pages/user_list_helper.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';

class FollowersPage extends StatelessWidget {
  final UserModel user;
  const FollowersPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    const String title = "Followers";

    return FollowersPageHelper(
      user: user,
      title: title,
    );
  }
}
