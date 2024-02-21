import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/cubit/auth/auth_cubit.dart';
import 'package:travel_the_world/cubit/post/post_cubit.dart';
import 'package:travel_the_world/UI/custom/custom_modal_item.dart';
import 'package:travel_the_world/UI/custom/custom_option_item.dart';
import 'package:travel_the_world/profile_widget.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';
import 'package:travel_the_world/themes/app_colors.dart';

class ProfileMainWidget extends StatefulWidget {
  final UserModel currentUser;
  const ProfileMainWidget({super.key, required this.currentUser});

  @override
  State<ProfileMainWidget> createState() => _ProfileMainWidgetState();
}

class _ProfileMainWidgetState extends State<ProfileMainWidget> {
  @override
  void initState() {
    BlocProvider.of<PostCubit>(context).getPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getBackgroundColor(context),
      appBar: buildAppBar(),
      body: buildProfileContent(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: getBackgroundColor(context),
      surfaceTintColor: getBackgroundColor(context),
      title: Text(widget.currentUser.username,
          style: const TextStyle(color: Colors.red)),
      actions: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: () {
              _openBottomModalSheet(context: context, user: widget.currentUser);
            },
            child: Icon(Icons.menu, color: Colors.red.shade100),
          ),
        ),
      ],
    );
  }

  Widget buildProfileContent() {
    return Container(
      color: getThemeColor(context, AppColors.white, AppColors.black),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                  color: const Color.fromARGB(255, 56, 128, 59),
                  child: Column(
                    children: [
                      buildUserInfo(),
                      sizeVertical(10),
                      Text(
                        widget.currentUser.name == ''
                            ? widget.currentUser.username
                            : widget.currentUser.name,
                        style: const TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      sizeVertical(10),
                      Text(
                        widget.currentUser.bio,
                        style: const TextStyle(color: AppColors.black),
                      ),
                    ],
                  )),
              sizeVertical(10),
              buildUserPosts(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUserInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: profileWidget(
                imageUrl: widget.currentUser.profileUrl, boxFit: BoxFit.cover),
          ),
        ),
        buildUserStats(),
      ],
    );
  }

  Widget buildUserStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildStat("Posts", widget.currentUser.totalPosts.toString()),
        sizeHorizontal(25),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, PageRoutes.FollowersPage,
                arguments: widget.currentUser);
          },
          child:
              buildStat("Followers", "${widget.currentUser.followers.length}"),
        ),
        sizeHorizontal(25),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, PageRoutes.FollowingPage,
                arguments: widget.currentUser);
          },
          child:
              buildStat("Following", "${widget.currentUser.following.length}"),
        ),
      ],
    );
  }

  Widget buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        sizeVertical(7),
        Text(
          label,
          style: const TextStyle(color: Colors.red),
        ),
      ],
    );
  }

  Widget buildUserPosts() {
    return BlocBuilder<PostCubit, PostState>(
      builder: (context, postState) {
        if (postState is PostLoaded) {
          final posts = postState.posts
              .where((element) => element.creatorUid == widget.currentUser.uid)
              .toList();
          return GridView.builder(
            itemCount: posts.length,
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, PageRoutes.PostDetailPage,
                    arguments: posts[index].postId),
                child: SizedBox(
                  width: 175,
                  height: 175,
                  child: profileWidget(
                    imageUrl: posts[index].postImageUrl,
                    boxFit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        } else if (postState is PostEmpty) {
          return const Center(
            child: Text("No post yet", style: TextStyle(color: Colors.red)),
          );
        }
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 15, maxWidth: 15),
            child: const CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  _openBottomModalSheet(
      {required BuildContext context, required UserModel user}) {
    return showModalBottomSheet(
        backgroundColor: getBackgroundColor(context),
        context: context,
        builder: (context) {
          return CustomModalItem(
            children: [
              CustomOptionItem(
                text: "Settings",
                onTap: () {
                  Navigator.pushNamed(context, PageRoutes.SettingsPage);
                },
              ),
              CustomOptionItem(
                text: "Edit Profile",
                onTap: () {
                  Navigator.pushNamed(context, PageRoutes.EditProfilePage,
                      arguments: user);
                },
              ),
              CustomOptionItem(
                text: "Logout",
                onTap: () {
                  BlocProvider.of<AuthCubit>(context).loggedOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, PageRoutes.SignInPage, (route) => false);
                },
              ),
            ],
          );
        });
  }
}
