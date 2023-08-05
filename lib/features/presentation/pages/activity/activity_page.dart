import 'package:flutter/material.dart';
import 'package:travel_the_world/constants.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Activity",
          style: TextStyle(color: blueColor),
        ),
      ),
    );
  }
}
