import 'package:flutter/material.dart';
import 'package:travel_the_world/constants.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Search",
          style: TextStyle(color: blueColor),
        ),
      ),
    );
  }
}
