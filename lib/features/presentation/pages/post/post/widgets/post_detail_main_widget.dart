import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/features/domain/entites/app_entity.dart';
import 'package:travel_the_world/features/domain/entites/post/post_entity.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/user/get_current_user_id_usecase.dart';
import 'package:travel_the_world/features/presentation/cubit/post/get_single_post.dart/get_single_post_cubit.dart';
import 'package:travel_the_world/features/presentation/cubit/post/post_cubit.dart';
import 'package:travel_the_world/features/presentation/pages/post/post/widgets/like_animation_widget.dart';
import 'package:travel_the_world/features/presentation/pages/shared_widgets/custom_bottom_sheet.dart';
import 'package:travel_the_world/features/presentation/pages/shared_widgets/option_item.dart';
import 'package:travel_the_world/profile_widget.dart';
import 'package:travel_the_world/injection_container.dart' as di;

class PostDetailMainWidget extends StatefulWidget {
  final String postId;
  const PostDetailMainWidget({Key? key, required this.postId})
      : super(key: key);

  @override
  State<PostDetailMainWidget> createState() => _PostDetailMainWidgetState();
}

class _PostDetailMainWidgetState extends State<PostDetailMainWidget> {
  String _currentUid = "";

  @override
  void initState() {
    BlocProvider.of<GetSinglePostCubit>(context)
        .getSinglePost(postId: widget.postId);

    di.sl<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
    super.initState();
  }

  bool _isLikeAnimating = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSinglePostCubit, GetSinglePostState>(
      builder: (context, getSinglePostState) {
        if (getSinglePostState is GetSinglePostLoaded) {
          final singlePost = getSinglePostState.post;
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: backgroundColor,
                title: const Text(
                  "Post Detail",
                  style: TextStyle(color: primaryColor),
                ),
              ),
              backgroundColor: backgroundColor,
              body: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                                    borderRadius: BorderRadius.circular(15),
                                    child: profileWidget(
                                        imageUrl: singlePost.userProfileUrl))),
                            sizeHorizontal(10),
                            Text('${singlePost.username}',
                                style: const TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        singlePost.creatorUid == _currentUid
                            ? GestureDetector(
                                onTap: () {
                                  _openBottomModalSheet(context, singlePost,
                                      BlocProvider.of<PostCubit>(context));
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
                                singlePost.likes!.contains(_currentUid)
                                    ? Icons.favorite
                                    : Icons.favorite_outline,
                                color: singlePost.likes!.contains(_currentUid)
                                    ? Colors.red
                                    : primaryColor,
                              ),
                            ),
                            //if (_isLikedButtonPressed) Visibility(child: _animation()),
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
                                color: primaryColor,
                              ),
                            ),
                            sizeHorizontal(10),
                            const Icon(
                              Icons.send,
                              color: primaryColor,
                            ),
                            sizeHorizontal(10),
                          ],
                        ),
                        const Icon(Icons.bookmark_border_rounded,
                            color: primaryColor),
                      ],
                    ),
                    sizeVertical(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${singlePost.totalLikes} likes',
                            style: const TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold)),
                        Text(
                          DateFormat("dd/MMM/yyyy")
                              .format(singlePost.createAt!.toDate()),
                          style: const TextStyle(color: darkGreyColor),
                        ),
                      ],
                    ),
                    sizeVertical(10),
                    Row(
                      children: [
                        Text("${singlePost.username}",
                            style: const TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w600)),
                        sizeHorizontal(10),
                        Text(
                          "${singlePost.description}",
                          style: const TextStyle(color: primaryColor),
                        ),
                      ],
                    ),
                    sizeVertical(10),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, PageRoutes.CommentPage,
                              arguments: AppEntity(
                                  uid: _currentUid, postId: singlePost.postId));
                        },
                        child: Text(
                          "View all ${singlePost.totalComments} comments",
                          style: const TextStyle(color: darkGreyColor),
                        )),
                    sizeVertical(10),
                  ],
                ),
              ),
            ),
          );
        }
        return const Scaffold(
          body: Row(
            children: [
              //Text("Loading...", style: TextStyle(color: Colors.white)),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        );
      },
    );
  }

  Stack _animation(singlePost) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 0.8,
          child: profileWidget(imageUrl: "${singlePost.postImageUrl}"),
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
        .likePost(post: PostEntity(postId: widget.postId));
  }
}

_openBottomModalSheet(
    BuildContext context, PostEntity post, PostCubit postCubit) {
  //
  deletePost() {
    BlocProvider.of<PostCubit>(context)
        .deletePost(post: PostEntity(postId: post.postId));
    Navigator.pop(context);
  }

  return showModalBottomSheet(
      backgroundColor: Colors.transparent.withOpacity(0.5),
      context: context,
      builder: (context) {
        return CustomBottomSheet(
          children: [
            OptionItem(
              text: "Settings",
              onTap: () {},
            ),
            OptionItem(
              text: "Delete Post",
              onTap: deletePost,
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
      });
}
