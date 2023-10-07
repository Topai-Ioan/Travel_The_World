import 'package:flutter/material.dart';
import 'package:travel_the_world/features/presentation/pages/user_list_pages/user_list_helper.dart';
import 'package:travel_the_world/services/models/posts/post_model.dart';

class LikeListPage extends StatelessWidget {
  final PostModel post;
  const LikeListPage({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String title = "Likes";

    return LikesListPageHelper(
      post: post,
      title: title,
    );
  }
}
