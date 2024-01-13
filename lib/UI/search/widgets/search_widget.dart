import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController controller;
  const SearchWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextFormField(
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
