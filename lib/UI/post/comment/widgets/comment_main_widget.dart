import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/services/models/app_entity.dart';
import 'package:travel_the_world/cubit/comment/comment_cubit.dart';
import 'package:travel_the_world/cubit/post/get_single_post.dart/get_single_post_cubit.dart';
import 'package:travel_the_world/cubit/reply/reply_cubit.dart';
import 'package:travel_the_world/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:travel_the_world/UI/post/comment/widgets/single_comment_widget.dart';
import 'package:travel_the_world/UI/shared_items/confirmation_dialog.dart';
import 'package:travel_the_world/UI/custom/custom_modal_item.dart';
import 'package:travel_the_world/UI/shared_items/custom_text_input.dart';
import 'package:travel_the_world/UI/custom/custom_option_item.dart';
import 'package:travel_the_world/profile_widget.dart';
import 'package:travel_the_world/services/firestore/auth/auth_service.dart';
import 'package:travel_the_world/services/models/comments/comment_model.dart';
import 'package:travel_the_world/services/models/posts/post_model.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';
import 'package:travel_the_world/themes/app_colors.dart';
import 'package:travel_the_world/themes/app_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:travel_the_world/injection_container.dart' as di;

class CommentMainWidget extends StatefulWidget {
  final AppEntity appEntity;

  const CommentMainWidget({super.key, required this.appEntity});

  @override
  State<CommentMainWidget> createState() => _CommentMainWidgetState();
}

class _CommentMainWidgetState extends State<CommentMainWidget> {
  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context)
        .getSingleUser(uid: widget.appEntity.uid);

    BlocProvider.of<GetSinglePostCubit>(context)
        .getSinglePost(postId: widget.appEntity.postId);

    BlocProvider.of<CommentCubit>(context)
        .getComments(postId: widget.appEntity.postId);

    super.initState();
  }

  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Comments",
          style: Fonts.f18w700(color: getTextColor(context)),
        ),
      ),
      body: buildCommentContent(),
    );
  }

  Widget buildCommentContent() {
    return BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
      builder: (context, singleUserState) {
        if (singleUserState is GetSingleUserLoaded) {
          final singleUser = singleUserState.user;
          return BlocBuilder<GetSinglePostCubit, GetSinglePostState>(
            builder: (context, singlePostState) {
              if (singlePostState is GetSinglePostLoaded) {
                final singlePost = singlePostState.post;
                return BlocBuilder<CommentCubit, CommentState>(
                  builder: (context, commentState) {
                    if (commentState is CommentLoaded) {
                      return buildCommentListView(
                          singleUser, singlePost, commentState.comments);
                    } else if (commentState is CommentEmpty) {
                      return Container();
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget buildCommentListView(
      UserModel singleUser, PostModel singlePost, List<CommentModel> comments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildPostHeader(singlePost),
            ],
          ),
        ),
        const Divider(
          thickness: 3,
          color: AppColors.darkOlive,
        ),
        sizeVertical(10),
        Expanded(
          child: ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final singleComment = comments[index];
              return BlocProvider<ReplyCubit>.value(
                value: di.sl<ReplyCubit>(),
                child: SingleCommentWidget(
                  currentUser: singleUser,
                  comment: singleComment,
                  onLongPressListener: () {
                    _openBottomModalSheet(
                      context: context,
                      comment: singleComment,
                    );
                  },
                  onLikeClickListener: () {
                    _likeComment(comment: singleComment);
                  },
                ),
              );
            },
          ),
        ),
        CustomCommentSection(
          currentUser: singleUser,
          hintText: "Post your comment...",
          descriptionController: _descriptionController,
          createComment: _createComment,
        ),
      ],
    );
  }

  Widget buildPostHeader(PostModel singlePost) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: profileWidget(
                      imageUrl: singlePost.userProfileUrl,
                      boxFit: BoxFit.cover),
                ),
              ),
              sizeHorizontal(10),
              Text(
                singlePost.username,
                style: Fonts.f16w600(color: getTextColor(context)),
              ),
            ],
          ),
          sizeVertical(10),
          Text(
            singlePost.description,
            style: Fonts.f16w400(color: getTextColor(context)),
          ),
        ],
      ),
    );
  }

  _createComment(UserModel currentUser) {
    BlocProvider.of<CommentCubit>(context)
        .createComment(
            comment: CommentModel(
      totalReplies: 0,
      commentId: const Uuid().v1(),
      createdAt: DateTime.now().toUtc(),
      likes: const [],
      username: currentUser.username,
      userProfileUrl: currentUser.profileUrl,
      description: _descriptionController.text,
      creatorUid: currentUser.uid,
      postId: widget.appEntity.postId,
    ))
        .then((value) {
      setState(() {
        _descriptionController.clear();
      });
    });
  }

  _openBottomModalSheet(
      {required BuildContext context, required CommentModel comment}) {
    showModalBottomSheet(
      backgroundColor: AppColors.transparent,
      context: context,
      builder: (context) {
        return CustomModalItem(
          children: [
            CustomOptionItem(
              text: "Delete Comment",
              onTap: () => _deleteComment(
                commentId: comment.commentId,
                postId: comment.postId,
              ),
            ),
            CustomOptionItem(
              text: "Edit Comment",
              onTap: () {
                Navigator.pushNamed(context, PageRoutes.UpdateCommentPage,
                    arguments: comment);
              },
            ),
            CustomOptionItem(
              text: "Settings",
              onTap: () {},
            ),
          ],
        );
      },
    );
  }

  _deleteComment({required String commentId, required String postId}) {
    final currentContext = context;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          message: 'Are you sure you want to delete this comment?',
          onYesPressed: () {
            BlocProvider.of<CommentCubit>(currentContext).deleteComment(
              comment: CommentModel(
                  commentId: commentId,
                  postId: postId,
                  creatorUid: AuthService().getCurrentUserId()!),
            );
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

  _likeComment({required CommentModel comment}) {
    BlocProvider.of<CommentCubit>(context).likeComment(
        comment:
            CommentModel(commentId: comment.commentId, postId: comment.postId));
  }
}
