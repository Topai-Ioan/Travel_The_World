import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/features/domain/entites/comment/comment_entity.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/user/get_current_user_id_usecase.dart';
import 'package:travel_the_world/features/presentation/pages/credential/widgets/form_container_widget.dart';
import 'package:travel_the_world/profile_widget.dart';
import 'package:travel_the_world/injection_container.dart' as di;

class SingleCommentWidget extends StatefulWidget {
  final CommentEntity comment;
  final VoidCallback? onLongPressListener;
  final VoidCallback? onLikeClickListener;
  const SingleCommentWidget(
      {Key? key,
      required this.comment,
      this.onLongPressListener,
      this.onLikeClickListener})
      : super(key: key);

  @override
  State<SingleCommentWidget> createState() => _SingleCommentWidgetState();
}

class _SingleCommentWidgetState extends State<SingleCommentWidget> {
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

  bool _isUserReplying = false;
  bool _isKeyboardOpenFromReplay = false;

  @override
  Widget build(BuildContext context) {
    _isKeyboardOpenFromReplay =
        _isUserReplying && MediaQuery.of(context).viewInsets.bottom > 0;
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
                        const Text(
                          "View Replays",
                          style: TextStyle(color: darkGreyColor, fontSize: 12),
                        ),
                      ],
                    ),
                    sizeVertical(10),
                    if (_isUserReplying)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const FormContainerWidget(
                              hintText: "Post your replay..."),
                          sizeVertical(10),
                          const Text(
                            "Post",
                            style: TextStyle(color: blueColor),
                          )
                        ],
                      )
                  ],
                ),
              ),
            ),
            //if (!_isUserReplying && !_isKeyboardOpenFromReplay)
          ],
        ),
      ),
    );
  }
}
