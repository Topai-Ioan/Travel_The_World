import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  final List<Widget> children;

  const CustomBottomSheet({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent.withOpacity(0.5),
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }
}
