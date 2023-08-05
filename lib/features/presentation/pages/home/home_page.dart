import 'package:flutter/material.dart';
import 'package:travel_the_world/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          title: Image.asset(
            "assets/images/logo.png",
            height: 30,
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.message_outlined,
                color: primaryColor,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: secondaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      sizeHorizontal(10),
                      const Text(
                        "Username",
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Icon(Icons.more_vert_rounded, color: primaryColor)
                ],
              )
            ],
          ),
        ));
  }
}
