import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/cubit/auth/auth_cubit.dart';
import 'package:travel_the_world/cubit/credential/credential_cubit.dart';
import 'package:travel_the_world/UI/main_screen/main_screen.dart';
import 'package:travel_the_world/UI/credential/widgets/form_container_widget.dart';
import 'package:travel_the_world/UI/shared_items/button_container_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_the_world/profile_widget.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';
import 'package:travel_the_world/themes/app_colors.dart';
import 'package:travel_the_world/themes/app_fonts.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isSigningUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  File? _image;
  Future selectImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          toast("No image selected");
        }
      });
    } catch (e) {
      toast("Some error occured $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<CredentialCubit, CredentialState>(
      listener: (context, credentialState) {
        if (credentialState is CredentialSuccess) {
          BlocProvider.of<AuthCubit>(context).loggedIn();
        }
        if (credentialState is CredentialFailure) {
          toast("Invalid credentials");
        }
      },
      builder: (context, credentialState) {
        if (credentialState is CredentialSuccess) {
          return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
            if (authState is Authenticated) {
              _emailController.dispose();
              _usernameController.dispose();
              _passwordController.dispose();
              return MainScreen(uid: authState.uid);
            } else {
              return _bodyWidget();
            }
          });
        }

        return _bodyWidget();
      },
    ));
  }

  _bodyWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(flex: 2, child: Container()),
          Center(
            child: Image.asset(
              "assets/images/logo.png",
            ),
          ),
          sizeVertical(30),
          Center(
            child: Stack(
              children: [
                SizedBox(
                    width: 75,
                    height: 75,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: profileWidget(image: _image))),
                Positioned(
                  right: -10,
                  bottom: -15,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: Icon(
                      Icons.add_a_photo,
                      color: getTextColor(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
          sizeVertical(30),
          FormContainerWidget(
            controller: _usernameController,
            hintText: "Username",
          ),
          sizeVertical(15),
          FormContainerWidget(
            controller: _emailController,
            hintText: "Email",
          ),
          sizeVertical(15),
          FormContainerWidget(
            controller: _passwordController,
            hintText: "Password",
            isPasswordField: true,
          ),
          sizeVertical(15),
          ButtonContainerWidget(
            textStyle: Fonts.f18w600(
              color: getTextColor(context),
            ),
            backgroundColor: getBackgroundColor(context),
            text: "Sign Up",
            onTapListener: () {
              _signUpUser();
            },
          ),
          sizeVertical(10),
          if (_isSigningUp)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Please wait",
                    style: Fonts.f16w400(color: AppColors.black)),
                sizeHorizontal(10),
                const CircularProgressIndicator()
              ],
            ),
          Flexible(flex: 2, child: Container()),
          const Divider(
            thickness: 3,
            color: AppColors.darkOlive,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already have and account? ",
                style: Fonts.f16w400(color: getTextColor(context)),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, PageRoutes.SignInPage, (route) => false);
                },
                child: Text(
                  "Sign In.",
                  style: Fonts.f18w600(
                    color: getTextColor(context),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _signUpUser() {
    setState(() {
      _isSigningUp = true;
    });
    BlocProvider.of<CredentialCubit>(context)
        .signUpUser(
          user: UserModel(
            email: _emailController.text,
            username: _usernameController.text,
            password: _passwordController.text,
            totalPosts: 0,
            followers: List.empty(),
            following: List.empty(),
            profileUrl: "",
            name: "",
            website: "",
            bio: "",
            imageFile: _image,
          ),
        )
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _passwordController.clear();

      _isSigningUp = false;
    });
  }
}
