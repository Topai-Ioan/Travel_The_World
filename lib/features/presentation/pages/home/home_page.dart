import 'package:flutter/material.dart';
import 'package:travel_the_world/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Home",
          style: TextStyle(color: blueColor),
        ),
      ),
    );
  }
}
