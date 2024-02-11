import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/profile_widget.dart';
import 'package:travel_the_world/services/firestore/auth/auth_service.dart';
import 'package:travel_the_world/services/models/replies/reply_model.dart';

class SingleReplyWidget extends StatefulWidget {
  final ReplyModel reply;
  final VoidCallback? onLongPressListener;
  final VoidCallback? onLikeClickListener;
  const SingleReplyWidget(
      {super.key,
      required this.reply,
      this.onLongPressListener,
      this.onLikeClickListener});

  @override
  State<SingleReplyWidget> createState() => _SingleReplyWidgetState();
}

class _SingleReplyWidgetState extends State<SingleReplyWidget> {
  String _currentUid = "";

  @override
  void initState() {
    final currentUserId = AuthService().getCurrentUserId()!;
    setState(() {
      _currentUid = currentUserId;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: widget.reply.creatorUid == _currentUid
          ? widget.onLongPressListener
          : null,
      child: Container(
        margin: const EdgeInsets.only(left: 10, top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: profileWidget(imageUrl: widget.reply.userProfileUrl),
              ),
            ),
            sizeHorizontal(10),
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
                          widget.reply.username,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: primaryColor),
                        ),
                        GestureDetector(
                            onTap: widget.onLikeClickListener,
                            child: Icon(
                              widget.reply.likes.contains(_currentUid)
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              size: 20,
                              color: widget.reply.likes.contains(_currentUid)
                                  ? Colors.red
                                  : darkGreyColor,
                            ))
                      ],
                    ),
                    sizeVertical(4),
                    Text(
                      widget.reply.description,
                      style: const TextStyle(color: primaryColor),
                    ),
                    sizeVertical(4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat("dd/MMM/yyy")
                              .format(widget.reply.createdAt!),
                          style: const TextStyle(color: darkGreyColor),
                        ),
                        Text(
                          "${widget.reply.likes.length} likes",
                          style: const TextStyle(color: darkGreyColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
