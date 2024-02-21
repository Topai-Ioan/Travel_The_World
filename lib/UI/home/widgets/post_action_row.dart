import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/cubit/post/post_cubit.dart';
import 'package:travel_the_world/services/models/app_entity.dart';
import 'package:travel_the_world/services/models/posts/post_model.dart';
import 'package:travel_the_world/themes/app_colors.dart';
import 'package:travel_the_world/themes/app_fonts.dart';

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
              child: Text(
                '${post.likes.length}',
                style: Fonts.f18w700(color: getTextColor(context)),
              ),
            ),
            GestureDetector(
              onTap: () {
                BlocProvider.of<PostCubit>(context)
                    .likePost(post: PostModel(postId: post.postId));
              },
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_outline,
                color: isLiked ? Colors.red : getTextColor(context),
              ),
            ),
            sizeHorizontal(10),
            Text(
              "${post.totalComments} ",
              style: Fonts.f18w700(color: getTextColor(context)),
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
                color: getTextColor(context),
              ),
            ),
            sizeHorizontal(10),
            Text(
              "0 ",
              style: Fonts.f18w700(color: getTextColor(context)),
            ),
            Icon(
              Icons.send,
              color: getTextColor(context),
            ),
            sizeHorizontal(10),
          ],
        ),
        Icon(Icons.bookmark_border_rounded, color: getTextColor(context)),
      ],
    );
  }
}
