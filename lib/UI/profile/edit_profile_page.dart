import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/cubit/user/user_cubit.dart';
import 'package:travel_the_world/UI/profile/widgets/profile_form_widget.dart';
import 'package:travel_the_world/UI/shared_items/custom_action_handler.dart';
import 'package:travel_the_world/profile_widget.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';
import 'package:travel_the_world/services/store_service.dart';
import 'package:travel_the_world/themes/app_colors.dart';
import 'package:travel_the_world/themes/app_fonts.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel currentUser;

  const EditProfilePage({super.key, required this.currentUser});

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
    super.initState();
    _nameController = TextEditingController(text: widget.currentUser.name);
    _usernameController =
        TextEditingController(text: widget.currentUser.username);
    _websiteController =
        TextEditingController(text: widget.currentUser.website);
    _bioController = TextEditingController(text: widget.currentUser.bio);
  }

  bool _isUpdating = false;
  File? _image;

  Future selectImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
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
      appBar: buildAppBar(),
      body: buildBody(actionHandler),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
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
            child: Icon(
              Icons.done,
              color: getThemeColor(context, AppColors.black, AppColors.white),
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
              child: Text(
                "Change profile photo",
                style: Fonts.f18w600(color: AppColors.darkOlive),
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
      await _updateUserData();
    } else {
      final profileUrl = await StoreService()
          .uploadImageProfilePicture(_image!, "ProfileImages");

      await _updateUserProfilePictureAndData(profileUrl: profileUrl);
      await StoreService().syncProfilePicture(profileUrl);
    }
  }

  _updateUserProfilePictureAndData({required String profileUrl}) async {
    BlocProvider.of<UserCubit>(context).updateUser(
      user: UserModel(profileUrl: profileUrl),
    );

    await _updateUserData();
  }

  _updateUserData() {
    BlocProvider.of<UserCubit>(context)
        .updateUser(
          user: UserModel(
              username: _usernameController!.text,
              bio: _bioController!.text,
              website: _websiteController!.text,
              name: _nameController!.text),
        )
        .then(
          (value) => _clear(),
        );
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
