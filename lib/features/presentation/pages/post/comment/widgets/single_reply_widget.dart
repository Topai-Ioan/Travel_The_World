import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/features/domain/entites/reply/reply_entity.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/user/get_current_user_id_usecase.dart';
import 'package:travel_the_world/profile_widget.dart';
import 'package:travel_the_world/injection_container.dart' as di;

class SingleReplyWidget extends StatefulWidget {
  final ReplyEntity reply;
  final VoidCallback? onLongPressListener;
  final VoidCallback? onLikeClickListener;
  const SingleReplyWidget(
      {Key? key,
      required this.reply,
      this.onLongPressListener,
      this.onLikeClickListener})
      : super(key: key);

  @override
  State<SingleReplyWidget> createState() => _SingleReplyWidgetState();
}

class _SingleReplyWidgetState extends State<SingleReplyWidget> {
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: widget.onLongPressListener,
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
                          "${widget.reply.username}",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: primaryColor),
                        ),
                        GestureDetector(
                            onTap: widget.onLikeClickListener,
                            child: Icon(
                              widget.reply.likes!.contains(_currentUid)
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              size: 20,
                              color: widget.reply.likes!.contains(_currentUid)
                                  ? Colors.red
                                  : darkGreyColor,
                            ))
                      ],
                    ),
                    sizeVertical(4),
                    Text(
                      "${widget.reply.description}",
                      style: const TextStyle(color: primaryColor),
                    ),
                    sizeVertical(4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat("dd/MMM/yyy")
                              .format(widget.reply.createAt!.toDate()),
                          style: const TextStyle(color: darkGreyColor),
                        ),
                        Text(
                          "${widget.reply.likes!.length} likes",
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
