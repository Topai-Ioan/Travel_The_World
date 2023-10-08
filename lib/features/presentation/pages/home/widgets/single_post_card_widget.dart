import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/features/domain/entites/app_entity.dart';
import 'package:travel_the_world/features/presentation/cubit/post/post_cubit.dart';
import 'package:travel_the_world/features/presentation/pages/post/post/widgets/like_animation_widget.dart';
import 'package:travel_the_world/features/presentation/pages/shared_items/confirmation_dialog.dart';
import 'package:travel_the_world/features/presentation/pages/shared_items/custom_bottom_sheet.dart';
import 'package:travel_the_world/features/presentation/pages/shared_items/option_item.dart';
import 'package:travel_the_world/profile_widget.dart';
import 'package:intl/intl.dart';
import 'package:travel_the_world/services/auth_service.dart';
import 'package:travel_the_world/services/models/posts/post_model.dart';

class SinglePostCardWidget extends StatefulWidget {
  final PostModel post;
  final PostCubit postCubit;
  const SinglePostCardWidget(
      {super.key, required this.post, required this.postCubit});

  @override
  State<SinglePostCardWidget> createState() => _SinglePostCardWidgetState();
}

class _SinglePostCardWidgetState extends State<SinglePostCardWidget> {
  String _currentUid = "";

  @override
  void initState() {
    final currentUid = AuthService().getCurrentUserId()!;
    setState(() {
      _currentUid = currentUid;
    });
    super.initState();
  }

  String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'a few seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return DateFormat("dd/MMM/yyyy").format(dateTime);
    }
  }

  bool _isLikeAnimating = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                        context, PageRoutes.SingleUserProfilePage,
                        arguments: widget.post.creatorUid);
                  },
                  child: Row(
                    children: [
                      SizedBox(
                          width: 40,
                          height: 40,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: profileWidget(
                                  imageUrl: widget.post.userProfileUrl,
                                  boxFit: BoxFit.cover))),
                      sizeHorizontal(10),
                      Text(widget.post.username,
                          style: const TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold)),
                      sizeHorizontal(5),
                      Text(
                        formatTimeAgo(widget.post.createdAt!),
                        style: const TextStyle(color: darkGreyColor),
                      ),
                    ],
                  ),
                ),
                widget.post.creatorUid == _currentUid
                    ? GestureDetector(
                        onTap: () {
                          _openBottomModalSheet(
                              context, widget.post, widget.postCubit);
                        },
                        child: const Icon(Icons.more_vert_rounded,
                            color: primaryColor),
                      )
                    : const SizedBox(
                        width: 0,
                        height: 0,
                      ),
              ],
            ),
            sizeVertical(10),
            GestureDetector(
              onDoubleTap: () {
                _likePost();
                setState(() {
                  _isLikeAnimating = true;
                });
              },
              child: _animation(),
            ),
            sizeVertical(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, PageRoutes.LikeListPage,
                            arguments: widget.post);
                      },
                      child: Text('${widget.post.likes.length}',
                          style: const TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                    ),
                    GestureDetector(
                      onTap: () {
                        _likePost();
                      },
                      child: Icon(
                        widget.post.likes.contains(_currentUid)
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        color: widget.post.likes.contains(_currentUid)
                            ? Colors.red
                            : primaryColor,
                      ),
                    ),
                    sizeHorizontal(10),
                    Text(
                      "${widget.post.totalComments} ",
                      style: const TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          PageRoutes.CommentPage,
                          arguments: AppEntity(
                              uid: _currentUid, postId: widget.post.postId),
                        );
                      },
                      child: const Icon(
                        Icons.comment_rounded,
                        color: primaryColor,
                      ),
                    ),
                    sizeHorizontal(10),
                    const Text(
                      "0 ",
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    const Icon(
                      Icons.send,
                      color: primaryColor,
                    ),
                    sizeHorizontal(10),
                  ],
                ),
                const Icon(Icons.bookmark_border_rounded, color: primaryColor),
              ],
            ),
            if (widget.post.description != "")
              Column(
                children: [
                  sizeVertical(10),
                  Row(
                    children: [
                      Text(
                        widget.post.description,
                        style: const TextStyle(color: primaryColor),
                      ),
                    ],
                  ),
                  sizeVertical(10),
                ],
              ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }

  Stack _animation() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          constraints: const BoxConstraints(minHeight: 200.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: profileWidget(imageUrl: widget.post.postImageUrl),
          ),
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _isLikeAnimating ? 1 : 0,
          child: LikeAnimationWidget(
              duration: const Duration(milliseconds: 200),
              isAnimating: _isLikeAnimating,
              onAnimationComplete: () {
                setState(() {
                  _isLikeAnimating = false;
                });
              },
              child: const Icon(
                Icons.favorite,
                size: 100,
                color: Colors.white,
              )),
        ),
      ],
    );
  }

  _likePost() {
    BlocProvider.of<PostCubit>(context)
        .likePost(post: PostModel(postId: widget.post.postId));
  }
}

_deletePost(BuildContext context, PostModel post, PostCubit postCubit) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ConfirmationDialog(
        message: 'Are you sure you want to delete this post?',
        onYesPressed: () {
          BlocProvider.of<PostCubit>(context)
              .deletePost(post: PostModel(postId: post.postId));
          Navigator.pop(context);
          Navigator.pop(context);
        },
        onNoPressed: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      );
    },
  );
}

_openBottomModalSheet(
    BuildContext context, PostModel post, PostCubit postCubit) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent.withOpacity(0.5),
    context: context,
    builder: (context) {
      return CustomModalItem(
        children: [
          OptionItem(
            text: "Settings",
            onTap: () {},
          ),
          OptionItem(
            text: "Delete Post",
            onTap: () {
              _deletePost(context, post, postCubit);
            },
          ),
          OptionItem(
            text: "Edit Post",
            onTap: () {
              Navigator.pushNamed(context, PageRoutes.UpdatePostPage,
                  arguments: post);
            },
          ),
        ],
      );
    },
  );
}
