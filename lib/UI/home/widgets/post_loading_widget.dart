import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:travel_the_world/constants.dart';

class PostLoadingWidget extends StatelessWidget {
  const PostLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 20;
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[200]!,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  sizeHorizontal(10),
                  Container(
                    width: 100,
                    height: 15.0,
                    color: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: width,
                height: 200, // Mimic the height of your image
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              Container(
                width: width,
                height: 30.0, // Mimic the height of your actions row
                color: Colors.white,
              ),
              const SizedBox(height: 10),
              const Divider(color: Colors.grey, thickness: 3),
            ],
          ),
        ),
      ),
    );
  }
}
