import 'package:flutter/material.dart';
import 'dart:developer';

class FaceWidget extends StatelessWidget {
  final Rect rect;
  final double scaleX, scaleY;

  const FaceWidget(
      {super.key,
      required this.rect,
      required this.scaleX,
      required this.scaleY});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: rect.left * scaleX,
      top: rect.top * scaleY,
      width: rect.width * scaleX,
      height: rect.height * scaleY,
      child: GestureDetector(
        onTap: () {
          log('Face bounding box tapped');
        },
        child: Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromARGB(166, 245, 143, 143),
          ),
          alignment: Alignment.center,
          child: const Text(
            'Add',
            style: TextStyle(
              color: Colors.black,
              fontSize: 8.0,
            ),
          ),
        ),
      ),
    );
  }
}
