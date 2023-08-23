import 'package:flutter/material.dart';
import 'package:travel_the_world/constants.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({Key? key}) : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  bool _isUserReplying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildCommentWidget(),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: _buildCommentRow(),
            ),
          ),
          _commentSection(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: backgroundColor,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Icon(Icons.arrow_back),
      ),
      title: const Text(
        'Comments',
        style: TextStyle(color: primaryColor),
      ),
    );
  }

  Widget _buildCommentWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: secondaryColor,
                shape: BoxShape.circle,
              ),
            ),
            sizeHorizontal(10),
            const Text(
              'Username',
              style: TextStyle(
                fontSize: 15,
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          "very nice description",
          style: TextStyle(color: primaryColor),
        ),
        const SizedBox(height: 10),
        const Divider(color: secondaryColor),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildCommentRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: secondaryColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
        sizeHorizontal(10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Username',
                style: TextStyle(
                  fontSize: 15,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              sizeVertical(5),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "this is a comment",
                    style: TextStyle(color: primaryColor),
                  ),
                  Icon(Icons.favorite_outlined, color: darkGreyColor, size: 20),
                ],
              ),
              sizeVertical(5),
              Row(
                children: [
                  const Text(
                    '08/08/2021',
                    style: TextStyle(color: darkGreyColor, fontSize: 12),
                  ),
                  sizeHorizontal(15),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isUserReplying = !_isUserReplying;
                      });
                    },
                    child: const Text(
                      'Reply',
                      style: TextStyle(color: darkGreyColor, fontSize: 12),
                    ),
                  ),
                  sizeHorizontal(15),
                  const Text(
                    'View Replies',
                    style: TextStyle(color: darkGreyColor, fontSize: 12),
                  ),
                  sizeHorizontal(15),
                ],
              ),
              _buildReplyWidget(_isUserReplying)
            ],
          ),
        ),
      ],
    );
  }

  Widget _commentSection() {
    return Container(
      width: double.infinity,
      height: 55,
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: secondaryColor,
              ),
              child: const Icon(
                Icons.person,
                color: primaryColor,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextFormField(
                  style: const TextStyle(color: primaryColor),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Post your comment...",
                    hintStyle: TextStyle(color: secondaryColor),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // Implement the functionality to post the comment
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                child: const Icon(Icons.send, color: blueColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyWidget(bool isReplying) {
    if (isReplying) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextFormField(
                      style: const TextStyle(color: primaryColor),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Post your reply...",
                        hintStyle: TextStyle(color: secondaryColor),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Implement the functionality to post the reply
                  },
                  child: Container(
                    padding: const EdgeInsets.all(11),
                    child: const Icon(
                      Icons.send,
                      color: blueColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return const SizedBox(width: 0, height: 0);
    }
  }
}
