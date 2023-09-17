import 'package:flutter/material.dart';

class CustomModalItem extends StatelessWidget {
  final List<Widget> children;

  const CustomModalItem({
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
