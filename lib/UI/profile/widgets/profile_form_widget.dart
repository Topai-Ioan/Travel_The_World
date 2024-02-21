import 'package:flutter/material.dart';
import 'package:travel_the_world/constants.dart';

class ProfileFormWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? title;
  //final TextStyle titleTextStyle;
  //final TextStyle hintTextStyle;
  final String? hintText;
  final Color? fillColor;
  const ProfileFormWidget({
    super.key,
    this.title,
    this.controller,
    this.hintText,
    this.fillColor = const Color.fromARGB(255, 23, 23, 23),
    //required this.titleTextStyle,
    //required this.hintTextStyle
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sizeVertical(15),
        Container(
          margin: const EdgeInsets.only(left: 8),
          child: Text(
            "$title",
            style: const TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: controller,
            style: const TextStyle(color: Colors.red),
            decoration: InputDecoration(
              labelStyle: const TextStyle(color: Colors.red),
              border: InputBorder.none,
              filled: true,
              hintText: "$hintText",
              fillColor: fillColor,
              hintStyle: const TextStyle(color: Colors.grey),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 1,
          color: Colors.grey[300],
        ),
        sizeVertical(10),
      ],
    );
  }
}
