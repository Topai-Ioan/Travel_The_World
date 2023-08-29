import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/features/domain/entites/post/post_entity.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/user/get_current_user_id_usecase.dart';
import 'package:travel_the_world/features/presentation/cubit/post/post_cubit.dart';
import 'package:travel_the_world/features/presentation/pages/post/widgets/like_animation_widget.dart';
import 'package:travel_the_world/profile_widget.dart';
import 'package:intl/intl.dart';
import 'package:travel_the_world/injection_container.dart' as di;

class SinglePostCardWidget extends StatefulWidget {
  final PostEntity post;
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SafeArea(
        //todo this here was overflowing: update, it is still overflowing
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
                                imageUrl: widget.post.userProfileUrl))),
                    sizeHorizontal(10),
                    Text('${widget.post.username}',
                        style: const TextStyle(
                            color: primaryColor, fontWeight: FontWeight.bold)),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    _openBottomModalSheet(
                        context, widget.post, widget.postCubit);
                  },
                  child:
                      const Icon(Icons.more_vert_rounded, color: primaryColor),
                )
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
                        _likePost();
                      },
                      child: Icon(
                        widget.post.likes!.contains(_currentUid)
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        color: widget.post.likes!.contains(_currentUid)
                            ? Colors.red
                            : primaryColor,
                      ),
                    ),
                    //if (_isLikedButtonPressed) Visibility(child: _animation()),
                    sizeHorizontal(10),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, PageRoutes.CommentPage);
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
                const Icon(Icons.bookmark_border_rounded, color: primaryColor),
              ],
            ),
            sizeVertical(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${widget.post.totalLikes} likes',
                    style: const TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold)),
                Text(
                  //todo maybe use datetine.now insead of timestamp
                  // cant do it, firebase accepts only timestamps
                  DateFormat("dd/MMM/yyyy")
                      .format(widget.post.createAt!.toDate()),
                  style: const TextStyle(color: darkGreyColor),
                ),
              ],
            ),
            sizeVertical(10),
            Row(
              children: [
                Text("${widget.post.username}",
                    style: const TextStyle(
                        color: primaryColor, fontWeight: FontWeight.w600)),
                sizeHorizontal(10),
                Text(
                  "${widget.post.description}",
                  style: const TextStyle(color: primaryColor),
                ),
              ],
            ),
            sizeVertical(10),
            Text(
              "view all ${widget.post.totalComments} comments",
              style: const TextStyle(color: darkGreyColor),
            ),
            sizeVertical(10),
          ],
        ),
      ),
    );
  }

  Stack _animation() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.30,
          child: profileWidget(imageUrl: "${widget.post.postImageUrl}"),
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
        .likePost(post: PostEntity(postId: widget.post.postId));
  }
}

_openBottomModalSheet(
    BuildContext context, PostEntity post, PostCubit postCubit) {
  deletePost() {
    postCubit.deletePost(post: PostEntity(postId: post.postId));
    Navigator.pop(context);
  }

  showModalBottomSheet(
      backgroundColor: Colors.transparent.withOpacity(0.5),
      context: context,
      builder: (context) {
        return Container(
          height: 150,
          color: Colors.transparent.withOpacity(0.5),
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _OptionItem(
                    text: "Settings",
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  const Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 8),
                  _OptionItem(
                    text: "Delete Post",
                    onTap: deletePost,
                  ),
                  const SizedBox(height: 7),
                  const Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 7),
                  _OptionItem(
                    text: "Edit Post",
                    onTap: () {
                      Navigator.pushNamed(context, PageRoutes.UpdatePostPage,
                          arguments: post);
                    },
                  ),
                  const SizedBox(height: 7),
                ],
              ),
            ),
          ),
        );
      });
}

class _OptionItem extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _OptionItem({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Text(
          text,
          style: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
