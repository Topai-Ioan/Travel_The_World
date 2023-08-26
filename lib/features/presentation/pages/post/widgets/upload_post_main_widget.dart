import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/features/domain/entites/post/post_entity.dart';
import 'package:travel_the_world/features/domain/entites/user/user_entity.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/post/create_post_usecase.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/storage/upload_image.dart';
import 'package:travel_the_world/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:travel_the_world/features/presentation/cubit/post/post_cubit.dart';
import 'package:travel_the_world/features/presentation/pages/profile/widgets/profile_form_widget.dart';
import 'package:travel_the_world/injection_container.dart' as di;
import 'package:travel_the_world/profile_widget.dart';

class UploadPostMainWidget extends StatefulWidget {
  final UserEntity currentUser;
  const UploadPostMainWidget({Key? key, required this.currentUser})
      : super(key: key);

  @override
  State<UploadPostMainWidget> createState() => _UploadPostMainWidgetState();
}

class _UploadPostMainWidgetState extends State<UploadPostMainWidget> {
  File? _image;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isUploading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

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
    return _image == null
        ? _uploadPostWidget()
        : Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: backgroundColor,
              leading: GestureDetector(
                  onTap: () => setState(() => _image = null),
                  child: const Icon(Icons.close, size: 28)),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: _submitPost,
                    child: const Icon(Icons.arrow_forward, size: 28),
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                // todo images with higher height are showing wrong
                children: [
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: profileWidget(image: _image),
                  ),
                  const SizedBox(height: 10),
                  ProfileFormWidget(
                      title: "Description", controller: _descriptionController),
                ],
              ),
            ),
          );
  }

  _submitPost() {
    setState(() {
      _isUploading = true;
    });
    di.sl<UploadImageUseCase>().call(_image!, "Posts").then((imageUrl) {
      _createSubmitPost(image: imageUrl);
    });
  }

  _createSubmitPost({required String image}) {
    BlocProvider.of<PostCubit>(context)
        .createPost(
            post: PostEntity(
          createAt: Timestamp.now(),
          userUid: widget.currentUser.uid,
          likes: [],
          //todo check if u want this format
          postId: "test",
          postImageUrl: image,
          totalComments: 0,
          totalLikes: 0,
          username: widget.currentUser.username,
          userProfileUrl: widget.currentUser.profileUrl,
        ))
        .then((value) => _clear());
    return;
  }

  _clear() {
    setState(() {
      _isUploading = false;
      _descriptionController.clear();
      _image = null;
    });
  }

  _uploadPostWidget() {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: GestureDetector(
          onTap: selectImage,
          child: Center(
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  color: secondaryColor.withOpacity(.3),
                  shape: BoxShape.circle),
              child: const Center(
                child: Icon(
                  Icons.upload,
                  color: primaryColor,
                  size: 40,
                ),
              ),
            ),
          ),
        ));
  }
}
