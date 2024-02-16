import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  const SearchBarWidget(
      {super.key, required this.controller, required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextFormField(
          focusNode: focusNode,
          controller: controller,
          style: TextStyle(color: Theme.of(context).primaryColor),
          decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.search,
                color: Theme.of(context).primaryColor,
              ),
              hintText: "Search",
              hintStyle: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 14)),
        ),
      ),
    );
  }
}
