import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/cubit/post/post_cubit.dart';
import 'package:travel_the_world/services/models/app_entity.dart';
import 'package:travel_the_world/services/models/posts/post_model.dart';

class PostActionsRow extends StatelessWidget {
  final PostModel post;
  final String currentUserId;

  const PostActionsRow({
    super.key,
    required this.post,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final isLiked = post.likes.contains(currentUserId);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, PageRoutes.LikeListPage,
                    arguments: post);
              },
              child: Text('${post.likes.length}',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ),
            GestureDetector(
              onTap: () {
                BlocProvider.of<PostCubit>(context)
                    .likePost(post: PostModel(postId: post.postId));
              },
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_outline,
                color: isLiked ? Colors.red : Theme.of(context).primaryColor,
              ),
            ),
            sizeHorizontal(10),
            Text(
              "${post.totalComments} ",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  PageRoutes.CommentPage,
                  arguments: AppEntity(uid: currentUserId, postId: post.postId),
                );
              },
              child: Icon(
                Icons.comment_rounded,
                color: Theme.of(context).primaryColor,
              ),
            ),
            sizeHorizontal(10),
            Text(
              "0 ",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            Icon(
              Icons.send,
              color: Theme.of(context).primaryColor,
            ),
            sizeHorizontal(10),
          ],
        ),
        const Icon(Icons.bookmark_border_rounded, color: primaryColor),
      ],
    );
  }
}
