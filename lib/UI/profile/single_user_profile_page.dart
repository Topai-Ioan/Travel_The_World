import 'package:flutter/material.dart';
import 'package:travel_the_world/UI/profile/widgets/single_user_profile_main_widget.dart';

class SingleUserProfilePage extends StatelessWidget {
  final String otherUserId;
  const SingleUserProfilePage({super.key, required this.otherUserId});

  @override
  Widget build(BuildContext context) {
    return SingleUserProfileMainWidget(
      otherUserId: otherUserId,
    );
  }
}
