import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/UI/shared_items/confirmation_dialog.dart';
import 'package:travel_the_world/UI/custom/custom_modal_item.dart';
import 'package:travel_the_world/UI/custom/custom_option_item.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/cubit/post/post_cubit.dart';
import 'package:travel_the_world/services/models/posts/post_model.dart';

class PostOptionsModal extends StatelessWidget {
  final PostModel post;

  const PostOptionsModal({super.key, required this.post});

  void _deletePost(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeletePostDialog(post: post);
      },
    );
  }

  void showOptions(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent.withOpacity(0.5),
      context: context,
      builder: (context) {
        return CustomModalItem(
          children: [
            CustomOptionItem(
              text: "Settings",
              onTap: () {},
            ),
            CustomOptionItem(
              text: "Delete Post",
              onTap: () {
                _deletePost(context);
              },
            ),
            CustomOptionItem(
              text: "Edit Post",
              onTap: () {
                Navigator.pushNamed(context, PageRoutes.UpdatePostPage,
                    arguments: post);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.more_vert),
      onPressed: () => showOptions(context),
    );
  }
}

class DeletePostDialog extends StatelessWidget {
  final PostModel post;

  const DeletePostDialog({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      message: 'Are you sure you want to delete this post?',
      onYesPressed: () {
        BlocProvider.of<PostCubit>(context).deletePost(postId: post.postId);
        Navigator.pop(context);
        Navigator.pop(context);
      },
      onNoPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }
}
