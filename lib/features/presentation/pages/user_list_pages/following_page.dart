import 'package:flutter/material.dart';
import 'package:travel_the_world/features/domain/entites/user/user_entity.dart';
import 'package:travel_the_world/features/presentation/pages/user_list_pages/user_list_helper.dart';

class FollowingPage extends StatelessWidget {
  final UserEntity user;
  const FollowingPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String title = "Following";

    return FollowingPageHelper(
      user: user,
      title: title,
    );
  }
}
