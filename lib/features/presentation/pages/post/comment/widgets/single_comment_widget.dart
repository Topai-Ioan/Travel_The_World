import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/features/domain/entites/comment/comment_entity.dart';
import 'package:travel_the_world/features/domain/entites/reply/reply_entity.dart';
import 'package:travel_the_world/features/domain/entites/user/user_entity.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/user/get_current_user_id_usecase.dart';
import 'package:travel_the_world/features/presentation/cubit/reply/reply_cubit.dart';
import 'package:travel_the_world/features/presentation/pages/credential/widgets/form_container_widget.dart';
import 'package:travel_the_world/features/presentation/pages/post/comment/widgets/single_reply_widget.dart';
import 'package:travel_the_world/profile_widget.dart';
import 'package:travel_the_world/injection_container.dart' as di;
import 'package:uuid/uuid.dart';

class SingleCommentWidget extends StatefulWidget {
  final CommentEntity comment;
  final VoidCallback? onLongPressListener;
  final VoidCallback? onLikeClickListener;
  final UserEntity? currentUser;

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

  @override
  void initState() {
    di.sl<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
    BlocProvider.of<ReplyCubit>(context).getReplies(
        reply: ReplyEntity(
            postId: widget.comment.postId,
            commentId: widget.comment.commentId));
    super.initState();
  }

  bool _isUserReplying = false;
  //bool _isKeyboardOpenFromReply = false;

  @override
  Widget build(BuildContext context) {
    //_isKeyboardOpenFromReply =
    //_isUserReplying && MediaQuery.of(context).viewInsets.bottom > 0;
    return InkWell(
      onLongPress: widget.onLongPressListener,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${widget.comment.username}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: primaryColor),
                        ),
                        GestureDetector(
                            onTap: widget.onLikeClickListener,
                            child: Icon(
                              widget.comment.likes!.contains(_currentUid)
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              size: 20,
                              color: widget.comment.likes!.contains(_currentUid)
                                  ? Colors.red
                                  : darkGreyColor,
                            ))
                      ],
                    ),
                    sizeVertical(4),
                    Text(
                      "${widget.comment.description}",
                      style: const TextStyle(color: primaryColor),
                    ),
                    sizeVertical(4),
                    Row(
                      children: [
                        Text(
                          DateFormat("dd/MMM/yyy")
                              .format(widget.comment.createAt!.toDate()),
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
                              style:
                                  TextStyle(color: darkGreyColor, fontSize: 12),
                            )),
                        sizeHorizontal(15),
                        GestureDetector(
                          onTap: () {
                            widget.comment.totalReplies == 0
                                ? toast("no replies")
                                : BlocProvider.of<ReplyCubit>(context)
                                    .getReplies(
                                        reply: ReplyEntity(
                                            postId: widget.comment.postId,
                                            commentId:
                                                widget.comment.commentId));
                          },
                          child: const Text(
                            "View Replies",
                            style:
                                TextStyle(color: darkGreyColor, fontSize: 12),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "${widget.comment.likes?.length} Likes",
                          style: const TextStyle(
                              color: darkGreyColor, fontSize: 12),
                        ),
                      ],
                    ),
                    sizeVertical(10),
                    BlocBuilder<ReplyCubit, ReplyState>(
                      builder: (context, replyState) {
                        if (replyState is ReplyLoaded) {
                          final replies = replyState.replies
                              .where((element) =>
                                  element.commentId == widget.comment.commentId)
                              .toList();
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemCount: replies.length,
                              itemBuilder: (context, index) {
                                return SingleReplyWidget(
                                  reply: replies[index],
                                  onLongPressListener: () {
                                    _openBottomModalSheet(
                                        context: context,
                                        reply: replies[index]);
                                  },
                                  onLikeClickListener: () {
                                    _likeReply(reply: replies[index]);
                                  },
                                );
                              });
                        }
                        return const SizedBox(
                          width: 0,
                          height: 0,
                        );
                      },
                    ),
                    sizeVertical(10),
                    _isUserReplying == true
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              FormContainerWidget(
                                  hintText: "Post your reply...",
                                  controller: _replyController),
                              sizeVertical(10),
                              GestureDetector(
                                onTap: () {
                                  _createReply();
                                },
                                child: const Text(
                                  "Post",
                                  style: TextStyle(color: blueColor),
                                ),
                              )
                            ],
                          )
                        : const SizedBox(
                            width: 0,
                            height: 0,
                          )
                  ],
                ),
              ),
            ),
            //if (!_isUserReplying && !_isKeyboardOpenFromReply)
          ],
        ),
      ),
    );
  }

  _createReply() {
    BlocProvider.of<ReplyCubit>(context)
        .createReply(
            reply: ReplyEntity(
      replyId: const Uuid().v1(),
      createAt: Timestamp.now(),
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
      {required BuildContext context, required ReplyEntity reply}) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent.withOpacity(0.5),
        context: context,
        builder: (context) {
          return Container(
            height: 100,
            color: Colors.transparent.withOpacity(0.5),
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _OptionItem(
                      text: "Delete Reply",
                      onTap: () {
                        _deleteReply(reply: reply);
                        setState(() {
                          _isUserReplying = false;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    const Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    _OptionItem(
                      text: "Edit Reply",
                      onTap: () {
                        Navigator.pushNamed(context, PageRoutes.UpdateReplyPage,
                            arguments: reply);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _deleteReply({required ReplyEntity reply}) {
    BlocProvider.of<ReplyCubit>(context).deleteReply(
        reply: ReplyEntity(
            postId: reply.postId,
            commentId: reply.commentId,
            replyId: reply.replyId));

    Navigator.pop(context);
  }

  _likeReply({required ReplyEntity reply}) {
    BlocProvider.of<ReplyCubit>(context).likeReply(
        reply: ReplyEntity(
            postId: reply.postId,
            commentId: reply.commentId,
            replyId: reply.replyId));
  }
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
