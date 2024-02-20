import 'package:flutter/material.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/themes/app_colors.dart';
import 'package:travel_the_world/themes/app_fonts.dart';

class PostDescription extends StatelessWidget {
  final String description;

  const PostDescription({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    if (description != "") {
      return Column(
        children: [
          sizeVertical(10),
          Row(
            children: [
              Text(
                description,
                style: Fonts.f16w400(color: AppColors.black),
              ),
            ],
          ),
          sizeVertical(10),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
