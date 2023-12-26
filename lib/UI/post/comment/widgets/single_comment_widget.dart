import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/cubit/reply/reply_cubit.dart';
import 'package:travel_the_world/UI/post/comment/widgets/single_reply_widget.dart';
import 'package:travel_the_world/UI/shared_items/confirmation_dialog.dart';
import 'package:travel_the_world/UI/shared_items/custom_bottom_sheet.dart';
import 'package:travel_the_world/UI/shared_items/custom_text_input.dart';
import 'package:travel_the_world/UI/shared_items/option_item.dart';
import 'package:travel_the_world/profile_widget.dart';
import 'package:travel_the_world/services/firestore/auth/auth_service.dart';
import 'package:travel_the_world/services/models/comments/comment_model.dart';
import 'package:travel_the_world/services/models/replies/reply_model.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';
import 'package:uuid/uuid.dart';

class SingleCommentWidget extends StatefulWidget {
  final CommentModel comment;
  final VoidCallback? onLongPressListener;
  final VoidCallback? onLikeClickListener;
  final UserModel? currentUser;

  const SingleCommentWidget(
      {Key? key,
      required this.comment,
      this.onLongPressListener,
      this.onLikeClickListener,
      this.currentUser})
      : super(key: key);

  @override
  State<SingleCommentWidget> createState() => _SingleCommentWidgetState();
}

class _SingleCommentWidgetState extends State<SingleCommentWidget> {
  final TextEditingController _replyController = TextEditingController();

  String _currentUid = "";
  bool _showReplies = false;

  @override
  void initState() {
    final currentUid = AuthService().getCurrentUserId()!;
    setState(() {
      _currentUid = currentUid;
    });
    BlocProvider.of<ReplyCubit>(context).getReplies(
        reply: ReplyModel(
            postId: widget.comment.postId,
            commentId: widget.comment.commentId));
    super.initState();
  }

  bool _isUserReplying = false;

  Widget buildCommentHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.comment.username,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        GestureDetector(
          onTap: widget.onLikeClickListener,
          child: Icon(
            widget.comment.likes.contains(_currentUid)
                ? Icons.favorite
                : Icons.favorite_outline,
            size: 20,
            color: widget.comment.likes.contains(_currentUid)
                ? Colors.red
                : darkGreyColor,
          ),
        ),
      ],
    );
  }

  Widget buildCommentText() {
    return Text(
      widget.comment.description,
      style: const TextStyle(color: primaryColor),
    );
  }

  Widget buildCommentFooter() {
    return Row(
      children: [
        Text(
          DateFormat("dd/MMM/yyy").format(widget.comment.createdAt!),
          style: const TextStyle(color: darkGreyColor),
        ),
        sizeHorizontal(15),
        GestureDetector(
          onTap: () {
            setState(() {
              _isUserReplying = !_isUserReplying;
            });
          },
          child: const Text(
            "Reply",
            style: TextStyle(color: darkGreyColor, fontSize: 12),
          ),
        ),
        sizeHorizontal(15),
        GestureDetector(
          onTap: () {
            setState(() {
              _showReplies = !_showReplies;
            });
            if (_showReplies) {
              widget.comment.totalReplies == 0
                  ? toast("no replies")
                  : BlocProvider.of<ReplyCubit>(context).getReplies(
                      reply: ReplyModel(
                        postId: widget.comment.postId,
                        commentId: widget.comment.commentId,
                      ),
                    );
            }
          },
          child: Text(
            _showReplies && widget.comment.totalReplies != 0
                ? "Hide Replies"
                : "View ${widget.comment.totalReplies} Replies",
            style: const TextStyle(
              color: darkGreyColor,
              fontSize: 12,
            ),
          ),
        ),
        const Spacer(),
        Text(
          "${widget.comment.likes.length} Likes",
          style: const TextStyle(color: darkGreyColor, fontSize: 12),
        ),
      ],
    );
  }

  Widget buildRepliesList(ReplyState replyState) {
    if (_showReplies && replyState is ReplyLoaded) {
      final replies = replyState.replies
          .where((element) => element.commentId == widget.comment.commentId)
          .toList();

      return ListView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: replies.length,
        itemBuilder: (context, index) {
          return SingleReplyWidget(
            reply: replies[index],
            onLongPressListener: () {
              _openBottomModalSheet(context: context, reply: replies[index]);
            },
            onLikeClickListener: () {
              _likeReply(reply: replies[index]);
            },
          );
        },
      );
    }

    return const SizedBox(width: 0, height: 0);
  }

  Widget buildReplySection() {
    return _isUserReplying == true
        ? CustomCommentSection(
            currentUser: widget.currentUser!,
            hintText: "Post your reply...",
            descriptionController: _replyController,
            createComment: _createReply,
          )
        : const SizedBox(width: 0, height: 0);
  }

  Widget buildCommentWidget() {
    return InkWell(
      onLongPress: widget.comment.creatorUid == _currentUid
          ? widget.onLongPressListener
          : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: profileWidget(imageUrl: widget.comment.userProfileUrl),
              ),
            ),
            sizeVertical(10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildCommentHeader(),
                    sizeVertical(4),
                    buildCommentText(),
                    sizeVertical(4),
                    buildCommentFooter(),
                    sizeVertical(10),
                    BlocBuilder<ReplyCubit, ReplyState>(
                      builder: (context, replyState) {
                        return buildRepliesList(replyState);
                      },
                    ),
                    sizeVertical(10),
                    buildReplySection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildCommentWidget();
  }

  _createReply(UserModel currentUser) {
    BlocProvider.of<ReplyCubit>(context)
        .createReply(
            reply: ReplyModel(
      replyId: const Uuid().v1(),
      createdAt: DateTime.now().toUtc(),
      likes: const [],
      username: widget.currentUser!.username,
      userProfileUrl: widget.currentUser!.profileUrl,
      creatorUid: widget.currentUser!.uid,
      postId: widget.comment.postId,
      commentId: widget.comment.commentId,
      description: _replyController.text,
    ))
        .then((value) {
      setState(() {
        _replyController.clear();
        _isUserReplying = false;
      });
    });
  }

  _openBottomModalSheet(
      {required BuildContext context, required ReplyModel reply}) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent.withOpacity(0.5),
        context: context,
        builder: (context) {
          return CustomModalItem(children: [
            OptionItem(
              text: "Delete Reply",
              onTap: () {
                _deleteReply(reply: reply);
                setState(() {
                  _isUserReplying = false;
                });
              },
            ),
            OptionItem(
              text: "Edit Reply",
              onTap: () {
                Navigator.pushNamed(context, PageRoutes.UpdateReplyPage,
                    arguments: reply);
              },
            )
          ]);
        });
  }

  _deleteReply({required ReplyModel reply}) {
    final currentContext = context;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          message: 'Are you sure you want to delete this post?',
          onYesPressed: () {
            BlocProvider.of<ReplyCubit>(currentContext).deleteReply(
                reply: ReplyModel(
                    postId: reply.postId,
                    commentId: reply.commentId,
                    replyId: reply.replyId));
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

  _likeReply({required ReplyModel reply}) {
    BlocProvider.of<ReplyCubit>(context).likeReply(
        reply: ReplyModel(
            postId: reply.postId,
            commentId: reply.commentId,
            replyId: reply.replyId));
  }
}
