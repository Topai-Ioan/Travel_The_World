import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:travel_the_world/features/presentation/cubit/post/post_cubit.dart';
import 'package:travel_the_world/features/presentation/pages/shared_items/custom_bottom_sheet.dart';
import 'package:travel_the_world/features/presentation/pages/shared_items/option_item.dart';
import 'package:travel_the_world/profile_widget.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';

class ProfileMainWidget extends StatefulWidget {
  final UserModel currentUser;
  const ProfileMainWidget({Key? key, required this.currentUser})
      : super(key: key);

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
      backgroundColor: backgroundColor,
      appBar: buildAppBar(),
      body: buildProfileContent(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: appBarColor,
      title: Text(widget.currentUser.username,
          style: const TextStyle(color: primaryColor)),
      actions: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: () {
              _openBottomModalSheet(context: context, user: widget.currentUser);
            },
            child: const Icon(Icons.menu, color: primaryColor),
          ),
        ),
      ],
    );
  }

  Widget buildProfileContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildUserInfo(),
            sizeVertical(10),
            Text(
              widget.currentUser.name == ''
                  ? widget.currentUser.username
                  : widget.currentUser.name,
              style: const TextStyle(
                  color: primaryColor, fontWeight: FontWeight.bold),
            ),
            sizeVertical(10),
            Text(
              widget.currentUser.bio,
              style: const TextStyle(color: primaryColor),
            ),
            sizeVertical(10),
            buildUserPosts(),
          ],
        ),
      ),
    );
  }

  Widget buildUserInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            color: primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        sizeVertical(7),
        Text(
          label,
          style: const TextStyle(color: primaryColor),
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
                  ),
                ),
              );
            },
          );
        } else if (postState is PostEmpty) {
          return const Center(
            child: Text("No post yet", style: TextStyle(color: primaryColor)),
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
        backgroundColor: Colors.transparent.withOpacity(0.5),
        context: context,
        builder: (context) {
          return CustomModalItem(
            children: [
              OptionItem(
                text: "Settings",
                onTap: () {},
              ),
              OptionItem(
                text: "Edit Profile",
                onTap: () {
                  Navigator.pushNamed(context, PageRoutes.EditProfilePage,
                      arguments: user);
                },
              ),
              OptionItem(
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
