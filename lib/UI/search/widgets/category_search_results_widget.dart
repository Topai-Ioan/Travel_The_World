import 'package:flutter/material.dart';
import 'package:travel_the_world/UI/custom/custom_elevated_button.dart';
import 'package:travel_the_world/UI/search/widgets/search_main_widget.dart';

class CategorySearchResultsWidget extends StatefulWidget {
  final String filterText;
  final ValueNotifier<bool> showUsersNotifier;

  const CategorySearchResultsWidget({
    super.key,
    required this.showUsersNotifier,
    required this.filterText,
  });

  @override
  State<CategorySearchResultsWidget> createState() =>
      _CategorySearchResultsWidgetState();
}

class _CategorySearchResultsWidgetState
    extends State<CategorySearchResultsWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomElevatedButton(
                  onPressed: () => widget.showUsersNotifier.value = true,
                  label: 'Users',
                ),
                const SizedBox(width: 16),
                CustomElevatedButton(
                  onPressed: () => widget.showUsersNotifier.value = false,
                  label: 'Photos',
                ),
              ],
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: widget.showUsersNotifier,
            builder: (context, showUsers, child) {
              if (showUsers) {
                return GetFilteredUsers(filterText: widget.filterText);
              } else {
                return GetFilteredPosts(filterText: widget.filterText);
              }
            },
          ),
        ],
      ),
    );
  }
}
