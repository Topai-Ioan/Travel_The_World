import 'package:flutter/material.dart';
import 'package:travel_the_world/constants.dart';

import '../upload_post/comment/comment_page.dart';

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
              ),
              sizeVertical(10),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.3,
                color: secondaryColor,
              ),
              sizeVertical(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.favorite,
                        color: primaryColor,
                      ),
                      sizeHorizontal(10),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CommentPage()));
                        },
                        child: const Icon(
                          Icons.comment_rounded,
                          color: primaryColor,
                        ),
                      ),
                      sizeHorizontal(10),
                      const Icon(
                        Icons.send,
                        color: primaryColor,
                      ),
                      sizeHorizontal(10),
                    ],
                  ),
                  const Icon(Icons.bookmark_border_rounded,
                      color: primaryColor),
                ],
              ),
              sizeVertical(10),
              const Text(
                "22 likes",
                style:
                    TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
              ),
              sizeVertical(10),
              Row(
                children: [
                  const Text(
                    "Username",
                    style: TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                  sizeHorizontal(10),
                  const Text(
                    "Description",
                    style: TextStyle(color: primaryColor),
                  ),
                ],
              ),
              sizeVertical(10),
              const Text(
                "view all x comments",
                style: TextStyle(color: darkGreyColor),
              ),
              sizeVertical(10),
              const Text(
                "01/01/2023",
                style: TextStyle(color: darkGreyColor),
              ),
            ],
          ),
        ));
  }
}
