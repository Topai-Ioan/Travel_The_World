import 'package:flutter/material.dart';
import 'package:travel_the_world/UI/user_list_pages/user_list_helper.dart';
import 'package:travel_the_world/services/models/posts/post_model.dart';

class LikeListPage extends StatelessWidget {
  final PostModel post;
  const LikeListPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    const String title = "Likes";

    return LikesListPageHelper(
      post: post,
      title: title,
    );
  }
}
