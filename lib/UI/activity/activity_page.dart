import 'package:flutter/material.dart';
import 'package:travel_the_world/themes/app_colors.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: getBackgroundColor(context),
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
