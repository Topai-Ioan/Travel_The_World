import 'package:flutter/material.dart';
import 'package:travel_the_world/constants.dart';

class PostDescription extends StatelessWidget {
  final String description;

  const PostDescription({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    if (description != "") {
      Column(
        children: [
          sizeVertical(10),
          Row(
            children: [
              Text(
                description,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ],
          ),
          sizeVertical(10),
        ],
      );
      const Divider(
        color: Colors.grey,
        thickness: 1,
      );
    }
    return const SizedBox.shrink();
  }
}
