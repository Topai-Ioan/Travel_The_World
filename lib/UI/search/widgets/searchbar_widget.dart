import 'package:flutter/material.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/themes/app_colors.dart';
import 'package:travel_the_world/themes/app_fonts.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  const SearchBarWidget(
      {super.key, required this.controller, required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: double.infinity,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextFormField(
              focusNode: focusNode,
              controller: controller,
              style: Fonts.f16w400(
                  color: getThemeColor(
                      context, AppColors.black, AppColors.darkPurple)),
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search,
                  color: getThemeColor(
                      context, AppColors.black, AppColors.darkPurple),
                ),
                hintText: "Search",
                hintStyle: Fonts.f16w400(
                    color: getThemeColor(
                        context, AppColors.red, AppColors.darkRed)),
              ),
            ),
          ),
          sizeVertical(10),
        ],
      ),
    );
  }
}
