import 'package:flutter/material.dart';

class CustomOptionItem extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const CustomOptionItem({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          const Divider(
            thickness: 1,
            color: Colors.grey,
          ),
          const SizedBox(height: 5),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 100),
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
