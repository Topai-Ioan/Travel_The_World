import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/cubit/post/post_cubit.dart';
import 'package:travel_the_world/UI/profile/widgets/profile_form_widget.dart';
import 'package:travel_the_world/UI/shared_items/custom_action_handler.dart';
import 'package:travel_the_world/profile_widget.dart';
import 'package:travel_the_world/services/models/posts/post_model.dart';
import 'package:travel_the_world/themes/app_colors.dart';
import 'package:travel_the_world/themes/app_fonts.dart';

class UpdatePostMainWidget extends StatefulWidget {
  final PostModel post;
  const UpdatePostMainWidget({super.key, required this.post});

  @override
  State<UpdatePostMainWidget> createState() => _UpdatePostMainWidgetState();
}

class _UpdatePostMainWidgetState extends State<UpdatePostMainWidget> {
  TextEditingController? _descriptionController;

  @override
  void initState() {
    _descriptionController =
        TextEditingController(text: widget.post.description);
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController!.dispose();
    super.dispose();
  }

  File? _image;
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    final actionHandler = ActionCooldownHandler();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Post",
          style: Fonts.f18w700(color: getTextColor(context)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {},
              icon: GestureDetector(
                onTap: () async => actionHandler.handleAction(_updatePost),
                child:
                    const Icon(Icons.check, color: AppColors.black, size: 28),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: profileWidget(imageUrl: widget.post.userProfileUrl),
                ),
              ),
              sizeVertical(10),
              Text(
                widget.post.username,
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              sizeVertical(10),
              SizedBox(
                width: double.infinity,
                height: 200,
                child: profileWidget(
                    imageUrl: widget.post.postImageUrl, image: _image),
              ),
              sizeVertical(10),
              ProfileFormWidget(
                controller: _descriptionController,
                title: "Description",
                hintText: "Enter the description...",
              ),
              sizeVertical(10),
              if (_isUploading)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Uploading...",
                        style: TextStyle(color: Colors.white)),
                    sizeHorizontal(10),
                    const CircularProgressIndicator()
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }

  _updatePost() async {
    setState(() {
      _isUploading = true;
    });

    if (_descriptionController != null) {
      _submitUpdateDescription();
    }
  }

  _submitUpdateDescription() {
    BlocProvider.of<PostCubit>(context)
        .updatePost(
          post: PostModel(
            postId: widget.post.postId,
            description: _descriptionController!.text,
          ),
        )
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _image = null;
      _descriptionController!.clear();
      _isUploading = false;
      Navigator.pop(context);
      Navigator.pop(context); // to close the menu
    });
  }
}
