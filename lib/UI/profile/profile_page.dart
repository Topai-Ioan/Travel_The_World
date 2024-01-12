import 'package:flutter/material.dart';
import 'package:travel_the_world/UI/profile/widgets/profile_main_widget.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';

class ProfilePage extends StatelessWidget {
  final UserModel currentUser;
  const ProfilePage({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return ProfileMainWidget(currentUser: currentUser);
  }
}
