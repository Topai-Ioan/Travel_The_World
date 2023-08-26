import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/features/domain/entites/user/user_entity.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/storage/upload_image.dart';
import 'package:travel_the_world/features/presentation/cubit/user/user_cubit.dart';
import 'package:travel_the_world/features/presentation/pages/profile/widgets/profile_form_widget.dart';
import 'package:travel_the_world/injection_container.dart' as di;
import 'package:travel_the_world/profile_widget.dart';

class EditProfilePage extends StatefulWidget {
  final UserEntity currentUser;

  const EditProfilePage({Key? key, required this.currentUser})
      : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController? _nameController;
  TextEditingController? _usernameController;
  TextEditingController? _websiteController;
  TextEditingController? _bioController;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.currentUser.name);
    _usernameController =
        TextEditingController(text: widget.currentUser.username);
    _websiteController =
        TextEditingController(text: widget.currentUser.website);
    _bioController = TextEditingController(text: widget.currentUser.bio);
    super.initState();
  }

  bool _isUpdating = false;

  File? _image;

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
        title: const Text(
          'Edit Profile',
        ),
        leading: GestureDetector(
          child: const Icon(
            Icons.close,
            size: 32,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: _updateUserProfileData,
              child: const Icon(
                Icons.done,
                color: blueColor,
                size: 32,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(children: [
            Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: profileWidget(
                      imageUrl: widget.currentUser.profileUrl, image: _image),
                ),
              ),
            ),
            sizeVertical(15),
            Center(
              child: GestureDetector(
                onTap: selectImage,
                child: const Text(
                  "Change profile photo",
                  style: TextStyle(
                      color: blueColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            ProfileFormWidget(title: "Name", controller: _nameController),
            ProfileFormWidget(
                title: "Username", controller: _usernameController),
            ProfileFormWidget(title: "Website", controller: _websiteController),
            ProfileFormWidget(title: "Bio", controller: _bioController),
            sizeVertical(10),
            if (_isUpdating)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Please wait...",
                    style: TextStyle(color: Colors.white),
                  ),
                  sizeHorizontal(10),
                  const CircularProgressIndicator()
                ],
              )
          ]),
        ),
      ),
    );
  }

  _updateUserProfileData() {
    setState(() => _isUpdating = true);
    if (_image == null) {
      _updateUserProfile("");
    } else {
      di
          .sl<UploadImageUseCase>()
          //todo dont harcode string
          .call(_image!, "profileImages", isPost: false)
          .then((profileUrl) {
        _updateUserProfile(profileUrl);
      });
    }
  }

  _updateUserProfile(String profileUrl) {
    BlocProvider.of<UserCubit>(context)
        .updateUser(
            user: UserEntity(
                uid: widget.currentUser.uid,
                username: _usernameController!.text,
                bio: _bioController!.text,
                website: _websiteController!.text,
                name: _nameController!.text,
                profileUrl: profileUrl))
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _isUpdating = false;
      _usernameController!.clear();
      _bioController!.clear();
      _websiteController!.clear();
      _nameController!.clear();
    });
    Navigator.pop(context);
    // todo find another way?
    Navigator.pop(context); // to close the modal bottom sheet
  }
}
