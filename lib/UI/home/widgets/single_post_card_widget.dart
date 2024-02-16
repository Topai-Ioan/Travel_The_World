import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/UI/home/widgets/post_action_row.dart';
import 'package:travel_the_world/UI/home/widgets/post_description.dart';
import 'package:travel_the_world/UI/home/widgets/post_header.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/cubit/post/post_cubit.dart';
import 'package:travel_the_world/UI/post/post/widgets/like_animation_widget.dart';
import 'package:travel_the_world/profile_widget.dart';
import 'package:travel_the_world/services/models/posts/post_model.dart';

class SinglePostCardWidget extends StatefulWidget {
  final PostModel post;
  final String currentUserId;
  const SinglePostCardWidget(
      {super.key, required this.post, required this.currentUserId});

  @override
  State<SinglePostCardWidget> createState() => _SinglePostCardWidgetState();
}

class _SinglePostCardWidgetState extends State<SinglePostCardWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PostHeader(
                post: widget.post,
                currentUserId: widget.currentUserId,
              ),
            ],
          ),
          sizeVertical(10),
          PostImageWithAnimation(
            imageUrl: widget.post.postImageUrl,
            onDoubleTap: () {
              BlocProvider.of<PostCubit>(context)
                  .likePost(post: PostModel(postId: widget.post.postId));
            },
          ),
          sizeVertical(10),
          PostActionsRow(
            post: widget.post,
            currentUserId: widget.currentUserId,
          ),
          PostDescription(description: widget.post.description),
        ],
      ),
    );
  }
}

class PostImageWithAnimation extends StatefulWidget {
  final String imageUrl;
  final VoidCallback onDoubleTap;

  const PostImageWithAnimation({
    super.key,
    required this.imageUrl,
    required this.onDoubleTap,
  });

  @override
  State<PostImageWithAnimation> createState() {
    return _PostImageWithAnimationState();
  }
}

class _PostImageWithAnimationState extends State<PostImageWithAnimation> {
  bool isLikeAnimating = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        setState(() {
          isLikeAnimating = true;
        });
        widget.onDoubleTap();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          PostImage(imageUrl: widget.imageUrl),
          LikeAnimationWidget(
              duration: const Duration(milliseconds: 200),
              isAnimating: isLikeAnimating,
              onAnimationComplete: () {
                setState(() {
                  isLikeAnimating = false;
                });
              },
              child: Icon(
                Icons.favorite,
                size: 100,
                color: Colors.white.withOpacity(isLikeAnimating ? 1 : 0),
              )),
        ],
      ),
    );
  }
}

class PostImage extends StatelessWidget {
  final String imageUrl;

  const PostImage({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      constraints: const BoxConstraints(minHeight: 200.0),
      child: SizedBox(
        width: screenWidth,
        child: profileWidget(imageUrl: imageUrl),
      ),
    );
  }
}
