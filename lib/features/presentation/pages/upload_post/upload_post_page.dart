import 'package:flutter/material.dart';
import 'package:travel_the_world/constants.dart';

class UploadPostPage extends StatelessWidget {
  const UploadPostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Upload",
          style: TextStyle(color: blueColor),
        ),
      ),
    );
  }
}
