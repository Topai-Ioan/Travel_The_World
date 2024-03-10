import 'package:flutter/material.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';
import 'package:travel_the_world/themes/app_colors.dart';
import 'package:travel_the_world/themes/app_fonts.dart';

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
        color: getThemeColor(context, AppColors.olive, AppColors.darkOlive),
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: descriptionController,
              style: Fonts.f16w400(
                  color: getThemeColor(
                      context, AppColors.darkOlive, AppColors.olive)),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: Fonts.f14w400(
                    color: getThemeColor(
                        context, AppColors.darkOlive, AppColors.olive)),
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
              child: Text(
                "Post",
                style: Fonts.f16w600(
                    color: getThemeColor(
                        context, AppColors.darkOlive, AppColors.olive)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
