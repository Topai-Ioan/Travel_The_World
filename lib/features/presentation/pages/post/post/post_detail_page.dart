import 'package:flutter/material.dart';
import 'package:travel_the_world/features/presentation/pages/post/post/widgets/post_detail_main_widget.dart';

class PostDetailPage extends StatelessWidget {
  final String postId;

  const PostDetailPage({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PostDetailMainWidget(postId: postId);
  }
}