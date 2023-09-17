import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/features/domain/entites/user/user_entity.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/post/sync_profile_picture.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/storage/upload_image_profile_picture.dart';
import 'package:travel_the_world/features/presentation/cubit/user/user_cubit.dart';
import 'package:travel_the_world/features/presentation/pages/profile/widgets/profile_form_widget.dart';
import 'package:travel_the_world/features/presentation/pages/shared_items/custom_action_handler.dart';
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
      toast("some error occurred $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final actionHandler = ActionCooldownHandler();
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: buildAppBar(),
      body: buildBody(actionHandler),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: appBarColor,
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
              color: primaryColor,
              size: 32,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBody(ActionCooldownHandler actionHandler) {
    return Padding(
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
                    imageUrl: widget.currentUser.profileUrl,
                    image: _image,
                    boxFit: BoxFit.cover),
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
          buildProfileForm(),
          sizeVertical(10),
          if (_isUpdating) buildUpdatingProgress()
        ]),
      ),
    );
  }

  Widget buildProfileForm() {
    return Column(
      children: [
        ProfileFormWidget(
            title: "Name",
            controller: _nameController,
            hintText: "Enter your name..."),
        ProfileFormWidget(
            title: "Username",
            controller: _usernameController,
            hintText: "Enter your new username..."),
        ProfileFormWidget(
          title: "Website",
          controller: _websiteController,
          hintText: "Enter your Website",
        ),
        ProfileFormWidget(
            title: "Bio",
            controller: _bioController,
            hintText: "Enter your Bio..."),
      ],
    );
  }

  Widget buildUpdatingProgress() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Please wait...",
          style: TextStyle(color: Colors.white),
        ),
        sizeHorizontal(10),
        const CircularProgressIndicator()
      ],
    );
  }

  Future<void> _updateUserProfileData() async {
    setState(() => _isUpdating = true);

    if (_image == null) {
      await _updateUserProfile("");
    } else {
      final profileUrl = await di
          .sl<UploadImageProfilePictureUseCase>()
          .call(_image!, "ProfileImages");

      await _updateUserProfile(profileUrl);
      await di.sl<SyncProfilePictureUseCase>().call(profileUrl);
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
    Navigator.pop(context);
  }
}
