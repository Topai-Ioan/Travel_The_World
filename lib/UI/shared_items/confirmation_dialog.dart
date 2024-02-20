import 'package:flutter/material.dart';
import 'package:travel_the_world/themes/app_colors.dart';

class ConfirmationDialog extends StatelessWidget {
  final String message;
  final VoidCallback onYesPressed;
  final VoidCallback onNoPressed;

  const ConfirmationDialog({
    super.key,
    required this.message,
    required this.onYesPressed,
    required this.onNoPressed,
  });

  @override
  Widget build(BuildContext context) {
    const textColor = Colors.white;
    return AlertDialog(
      backgroundColor: getThemeColor(context, AppColors.white, AppColors.black),
      title: const Text(
        'Confirmation',
        style: TextStyle(color: textColor),
      ),
      content: Text(message, style: const TextStyle(color: textColor)),
      actions: <Widget>[
        TextButton(
          onPressed: onNoPressed,
          child: const Text(
            'No',
            style: TextStyle(color: textColor),
          ),
        ),
        TextButton(
          onPressed: onYesPressed,
          child: const Text(
            'Yes',
            style: TextStyle(color: textColor),
          ),
        ),
      ],
    );
  }
}
