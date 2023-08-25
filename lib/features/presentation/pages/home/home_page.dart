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
          child: SafeArea(
            //todo this here was overflowing: update, it is still overflowing
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
                    GestureDetector(
                      onTap: () {
                        _openBottomModalSheet(context);
                      },
                      child: const Icon(Icons.more_vert_rounded,
                          color: primaryColor),
                    )
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
                            Navigator.pushNamed(
                                context, PageRoutes.CommentPage);
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
                  style: TextStyle(
                      color: primaryColor, fontWeight: FontWeight.bold),
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
          ),
        ));
  }
}

_openBottomModalSheet(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent.withOpacity(0.5),
    context: context,
    builder: (context) {
      return _ModalContent();
    },
  );
}

class _ModalContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      color: Colors.transparent.withOpacity(0.5),
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _OptionItem(
                text: "Settings",
                onTap: () {},
              ),
              const SizedBox(height: 8),
              const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              const SizedBox(height: 8),
              _OptionItem(
                text: "Delete Post",
                onTap: () {},
              ),
              const SizedBox(height: 7),
              const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              const SizedBox(height: 7),
              _OptionItem(
                text: "Edit Post",
                onTap: () {
                  Navigator.pushNamed(context, PageRoutes.EditPostPage);
                },
              ),
              const SizedBox(height: 7),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionItem extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _OptionItem({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Text(
          text,
          style: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
