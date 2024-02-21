import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/cubit/reply/reply_cubit.dart';
import 'package:travel_the_world/UI/shared_items/button_container_widget.dart';
import 'package:travel_the_world/UI/profile/widgets/profile_form_widget.dart';
import 'package:travel_the_world/services/models/replies/reply_model.dart';
import 'package:travel_the_world/themes/app_colors.dart';
import 'package:travel_the_world/themes/app_fonts.dart';

class EditReplyMainWidget extends StatefulWidget {
  final ReplyModel reply;
  const EditReplyMainWidget({super.key, required this.reply});

  @override
  State<EditReplyMainWidget> createState() => _EditReplyMainWidgetState();
}

class _EditReplyMainWidgetState extends State<EditReplyMainWidget> {
  TextEditingController? _descriptionController;

  bool _isReplyUpdating = false;

  @override
  void initState() {
    _descriptionController =
        TextEditingController(text: widget.reply.description);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: getBackgroundColor(context),
        title: const Text("Edit Reply"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(
          children: [
            ProfileFormWidget(
              title: "description",
              controller: _descriptionController,
            ),
            sizeVertical(10),
            ButtonContainerWidget(
              textStyle: Fonts.f16w400(color: Colors.blue),
              text: "Save Changes",
              onTapListener: () {
                _editReply();
              },
            ),
            sizeVertical(10),
            _isReplyUpdating == true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Updating...",
                        style: TextStyle(color: Colors.white),
                      ),
                      sizeHorizontal(10),
                      const CircularProgressIndicator(),
                    ],
                  )
                : const SizedBox(
                    width: 0,
                    height: 0,
                  )
          ],
        ),
      ),
    );
  }

  _editReply() {
    setState(() {
      _isReplyUpdating = true;
    });
    BlocProvider.of<ReplyCubit>(context)
        .updateReply(
            reply: ReplyModel(
                postId: widget.reply.postId,
                commentId: widget.reply.commentId,
                replyId: widget.reply.replyId,
                description: _descriptionController!.text))
        .then((value) {
      setState(() {
        _isReplyUpdating = false;
        _descriptionController!.clear();
      });
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }
}
