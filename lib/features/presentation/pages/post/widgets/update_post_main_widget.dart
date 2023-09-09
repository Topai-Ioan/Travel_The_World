import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/features/domain/entites/post/post_entity.dart';
import 'package:travel_the_world/features/presentation/cubit/post/post_cubit.dart';
import 'package:travel_the_world/features/presentation/pages/profile/widgets/profile_form_widget.dart';
import 'package:travel_the_world/profile_widget.dart';

class UpdatePostMainWidget extends StatefulWidget {
  final PostEntity post;
  const UpdatePostMainWidget({super.key, required this.post});

  @override
  State<UpdatePostMainWidget> createState() => _UpdatePostMainWidgetState();
}

// TODO when a post is updated (changed with anoteher photo) in the db we need to delete the old photo
// TODO i dont think we want to update the photo like this (changing the photo with another)
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
  Future selectImage() async {
    try {
      final pickedFile = await ImagePicker.platform
          .getImageFromSource(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print("no image has been selected");
        }
      });
    } catch (e) {
      toast("some error occured $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text("EditPost"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {},
              icon: GestureDetector(
                onTap: _updatePost,
                child: const Icon(Icons.check, color: blueColor, size: 28),
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
                "${widget.post.username}",
                style: const TextStyle(
                    color: primaryColor,
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
          post: PostEntity(
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
