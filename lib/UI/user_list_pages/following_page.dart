import 'package:flutter/material.dart';
import 'package:travel_the_world/UI/user_list_pages/user_list_helper.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';

class FollowingPage extends StatelessWidget {
  final UserModel user;
  const FollowingPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    const String title = "Following";

    return FollowingPageHelper(
      user: user,
      title: title,
    );
  }
}
