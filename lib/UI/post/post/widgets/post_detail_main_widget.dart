import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/services/models/app_entity.dart';
import 'package:travel_the_world/cubit/post/get_single_post.dart/get_single_post_cubit.dart';
import 'package:travel_the_world/cubit/post/post_cubit.dart';
import 'package:travel_the_world/UI/post/post/widgets/like_animation_widget.dart';
import 'package:travel_the_world/UI/custom/custom_modal_item.dart';
import 'package:travel_the_world/UI/custom/custom_option_item.dart';
import 'package:travel_the_world/profile_widget.dart';
import 'package:travel_the_world/services/firestore/auth/auth_service.dart';
import 'package:travel_the_world/services/models/posts/post_model.dart';
import 'package:travel_the_world/themes/app_colors.dart';
import 'package:travel_the_world/themes/app_fonts.dart';

class PostDetailMainWidget extends StatefulWidget {
  final String postId;
  const PostDetailMainWidget({super.key, required this.postId});

  @override
  State<PostDetailMainWidget> createState() => _PostDetailMainWidgetState();
}

class _PostDetailMainWidgetState extends State<PostDetailMainWidget> {
  String _currentUid = "";

  @override
  void initState() {
    super.initState();

    final currentUid = AuthService().getCurrentUserId()!;
    setState(() {
      _currentUid = currentUid;
    });
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
    BlocProvider.of<GetSinglePostCubit>(context)
        .getSinglePost(postId: widget.postId);
    return BlocBuilder<PostCubit, PostState>(
      builder: (context, postState) {
        return BlocBuilder<GetSinglePostCubit, GetSinglePostState>(
          builder: (context, getSinglePostState) {
            if (getSinglePostState is GetSinglePostLoaded) {
              final singlePost = getSinglePostState.post;
              return SafeArea(
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: getBackgroundColor(context),
                    title: Text(
                      "Post Detail",
                      style: Fonts.f18w700(color: AppColors.darkOlive),
                    ),
                  ),
                  backgroundColor: getBackgroundColor(context),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: profileWidget(
                                              imageUrl:
                                                  singlePost.userProfileUrl))),
                                  sizeHorizontal(10),
                                  Text(singlePost.username,
                                      style: Fonts.f16w700(
                                          color: AppColors.darkPurple)),
                                ],
                              ),
                              if (singlePost.creatorUid == _currentUid)
                                GestureDetector(
                                  onTap: () {
                                    _openBottomModalSheet(context, singlePost,
                                        BlocProvider.of<PostCubit>(context));
                                  },
                                  child: const Icon(Icons.more_vert_rounded,
                                      color: AppColors.black),
                                )
                            ],
                          ),
                          sizeVertical(10),
                          GestureDetector(
                            onDoubleTap: () {
                              _likePost();
                            },
                            child: _animation(singlePost),
                          ),
                          sizeVertical(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _likePost();
                                    },
                                    child: Icon(
                                      singlePost.likes.contains(_currentUid)
                                          ? Icons.favorite
                                          : Icons.favorite_outline,
                                      color:
                                          singlePost.likes.contains(_currentUid)
                                              ? Colors.red
                                              : AppColors.black,
                                    ),
                                  ),
                                  sizeHorizontal(10),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        PageRoutes.CommentPage,
                                        arguments: AppEntity(
                                            uid: _currentUid,
                                            postId: singlePost.postId),
                                      );
                                    },
                                    child: const Icon(
                                      Icons.comment_rounded,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  sizeHorizontal(10),
                                  const Icon(
                                    Icons.send,
                                    color: AppColors.black,
                                  ),
                                  sizeHorizontal(10),
                                ],
                              ),
                              const Icon(Icons.bookmark_border_rounded,
                                  color: AppColors.black),
                            ],
                          ),
                          sizeVertical(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${singlePost.likes.length} likes',
                                  style:
                                      Fonts.f16w400(color: AppColors.darkRed)),
                              Text(
                                DateFormat("dd/MMM/yyyy")
                                    .format(singlePost.createdAt!),
                                style: Fonts.f16w400(color: AppColors.darkRed),
                              ),
                            ],
                          ),
                          sizeVertical(10),
                          Row(
                            children: [
                              Text(singlePost.username,
                                  style: Fonts.f16w700(
                                      color: AppColors.darkPurple)),
                              sizeHorizontal(10),
                              Text(
                                singlePost.description,
                                style: Fonts.f16w400(color: AppColors.black),
                              ),
                            ],
                          ),
                          sizeVertical(10),
                          GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, PageRoutes.CommentPage,
                                    arguments: AppEntity(
                                        uid: _currentUid,
                                        postId: singlePost.postId));
                              },
                              child: Text(
                                "View all ${singlePost.totalComments} comments",
                                style:
                                    Fonts.f16w400(color: AppColors.darkOlive),
                              )),
                          sizeVertical(10),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            return Scaffold(
              body: Row(
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(maxHeight: 15, maxWidth: 15),
                      child: const CircularProgressIndicator(),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Stack _animation(singlePost) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          constraints: const BoxConstraints(minHeight: 200.0),
          child: SizedBox(
            child: profileWidget(imageUrl: singlePost.postImageUrl),
          ),
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _isLikeAnimating ? 1 : 0,
          child: LikeAnimationWidget(
            duration: const Duration(milliseconds: 200),
            isAnimating: _isLikeAnimating,
            onAnimationComplete: () {},
            child: const Icon(
              Icons.favorite,
              size: 100,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  _likePost() {
    setState(() {
      _isLikeAnimating = true;
    });
    BlocProvider.of<PostCubit>(context)
        .likePost(post: PostModel(postId: widget.postId))
        .then((_) {
      setState(() {
        _isLikeAnimating = false;
      });
    });
  }
}

_openBottomModalSheet(
    BuildContext context, PostModel post, PostCubit postCubit) {
  //
  deletePost() {
    BlocProvider.of<PostCubit>(context).deletePost(postId: post.postId);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  return showModalBottomSheet(
      backgroundColor: getBackgroundColor(context),
      context: context,
      builder: (context) {
        return CustomModalItem(
          children: [
            CustomOptionItem(
              text: "Settings",
              onTap: () {},
            ),
            CustomOptionItem(
              text: "Delete Post",
              onTap: deletePost,
            ),
            CustomOptionItem(
              text: "Edit Post",
              onTap: () {
                Navigator.pushNamed(context, PageRoutes.UpdatePostPage,
                    arguments: post);
              },
            ),
          ],
        );
      });
}
