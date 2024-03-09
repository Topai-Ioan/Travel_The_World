import 'package:flutter/material.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/themes/app_colors.dart';

class ProfileFormWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? title;
  //final TextStyle titleTextStyle;
  //final TextStyle hintTextStyle;
  final String? hintText;
  const ProfileFormWidget({
    super.key,
    this.title,
    this.controller,
    this.hintText,
    //required this.titleTextStyle,
    //required this.hintTextStyle
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sizeVertical(15),
        Container(
          margin: const EdgeInsets.only(left: 8),
          child: Text(
            "$title",
            style: TextStyle(
                color: getThemeColor(context, AppColors.black, AppColors.white),
                fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: TextFormField(
            controller: controller,
            style: TextStyle(
              color:
                  getThemeColor(context, AppColors.darkOlive, AppColors.olive),
            ),
            decoration: InputDecoration(
              labelStyle: const TextStyle(color: AppColors.darkOlive),
              border: InputBorder.none,
              filled: true,
              hintText: "$hintText",
              fillColor:
                  getThemeColor(context, AppColors.olive, AppColors.darkOlive),
              hintStyle: TextStyle(
                color: getThemeColor(
                    context, AppColors.darkOlive, AppColors.olive),
              ),
            ),
          ),
        ),
        Divider(
          color: getThemeColor(context, AppColors.darkOlive, AppColors.olive),
          thickness: 1,
        ),
        sizeVertical(5),
      ],
    );
  }
}
