import 'package:flutter/material.dart';
import 'package:travel_the_world/constants.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Profile",
          style: TextStyle(color: blueColor),
        ),
      ),
    );
  }
}
