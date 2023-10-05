import 'package:flutter/material.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';

class CustomCommentSection extends StatelessWidget {
  final UserModel currentUser;
  final String hintText;
  final TextEditingController descriptionController;
  final void Function(UserModel) createComment;

  const CustomCommentSection({
    super.key,
    required this.currentUser,
    required this.hintText,
    required this.descriptionController,
    required this.createComment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: descriptionController,
              style: const TextStyle(color: primaryColor),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: secondaryColor),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              createComment(currentUser);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: const Text(
                "Post",
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
