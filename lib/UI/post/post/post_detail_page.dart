import 'package:flutter/material.dart';
import 'package:travel_the_world/UI/post/post/widgets/post_detail_main_widget.dart';

class PostDetailPage extends StatelessWidget {
  final String postId;

  const PostDetailPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return PostDetailMainWidget(postId: postId);
  }
}
