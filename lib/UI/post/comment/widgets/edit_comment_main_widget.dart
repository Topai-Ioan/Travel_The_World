import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/cubit/comment/comment_cubit.dart';
import 'package:travel_the_world/UI/shared_items/button_container_widget.dart';
import 'package:travel_the_world/UI/profile/widgets/profile_form_widget.dart';
import 'package:travel_the_world/services/models/comments/comment_model.dart';
import 'package:travel_the_world/themes/app_colors.dart';
import 'package:travel_the_world/themes/app_fonts.dart';

class EditCommentMainWidget extends StatefulWidget {
  final CommentModel comment;
  const EditCommentMainWidget({super.key, required this.comment});

  @override
  State<EditCommentMainWidget> createState() => _EditCommentMainWidgetState();
}

class _EditCommentMainWidgetState extends State<EditCommentMainWidget> {
  TextEditingController? _descriptionController;

  bool _isCommentUpdating = false;

  @override
  void initState() {
    _descriptionController =
        TextEditingController(text: widget.comment.description);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: getBackgroundColor(context),
        title: Text(
          "Edit Comment",
          style: Fonts.f18w700(color: getTextColor(context)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(
          children: [
            ProfileFormWidget(
              hintText: "Comment",
              title: "Comment",
              controller: _descriptionController,
            ),
            sizeVertical(10),
            ButtonContainerWidget(
              textStyle: Fonts.f16w400(color: Colors.blue),
              text: "Save Changes",
              onTapListener: () {
                _editComment();
              },
            ),
            sizeVertical(10),
            if (_isCommentUpdating)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Updating...",
                      style: TextStyle(color: Colors.white)),
                  sizeHorizontal(10),
                  const CircularProgressIndicator(),
                ],
              )
          ],
        ),
      ),
    );
  }

  _editComment() {
    setState(() {
      _isCommentUpdating = true;
    });
    BlocProvider.of<CommentCubit>(context)
        .updateComment(
            comment: CommentModel(
                postId: widget.comment.postId,
                commentId: widget.comment.commentId,
                description: _descriptionController!.text))
        .then((value) {
      setState(() {
        _isCommentUpdating = false;
        _descriptionController!.clear();
      });
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }
}
