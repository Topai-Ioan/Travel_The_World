import 'package:flutter/material.dart';
import 'package:travel_the_world/themes/app_colors.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: getThemeColor(context, AppColors.white, AppColors.black),
      appBar: AppBar(
        backgroundColor:
            getThemeColor(context, AppColors.white, AppColors.black),
        title: Text(
          "Activity",
          style: TextStyle(
            color: colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
