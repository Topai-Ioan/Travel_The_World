import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/cubit/auth/auth_cubit.dart';
import 'package:travel_the_world/cubit/post/post_cubit.dart';
import 'package:travel_the_world/UI/custom/custom_modal_item.dart';
import 'package:travel_the_world/UI/custom/custom_option_item.dart';
import 'package:travel_the_world/profile_widget.dart';
import 'package:travel_the_world/services/models/posts/post_model.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';
import 'package:travel_the_world/themes/app_colors.dart';
import 'package:travel_the_world/themes/app_fonts.dart';

class ProfileMainWidget extends StatefulWidget {
  final UserModel currentUser;
  const ProfileMainWidget({super.key, required this.currentUser});

  @override
  State<ProfileMainWidget> createState() => _ProfileMainWidgetState();
}

class _ProfileMainWidgetState extends State<ProfileMainWidget> {
  final ScrollController _scrollController = ScrollController();
  List<PostModel> _displayedPosts = [];
  final int _pageSize = 8;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.position.pixels) {
      _loadMorePosts();
    }
  }

  void _loadMorePosts() async {
    _displayedPosts = _displayedPosts.take(_pageSize).toList();

    final int remainingPostsCount =
        _displayedPosts.length - _displayedPosts.length;

    if (remainingPostsCount > 0) {
      final int postsToAdd = min(remainingPostsCount, _pageSize);
      List<PostModel> newPosts = _displayedPosts
          .getRange(
            _displayedPosts.length,
            _displayedPosts.length + postsToAdd,
          )
          .toList();

      setState(() {
        _displayedPosts.addAll(newPosts);
      });
    }
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
      title: Text(
        widget.currentUser.username,
        style: TextStyle(
            color: getThemeColor(
              context,
              AppColors.black,
              AppColors.white,
            ),
            fontWeight: FontWeight.w600),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            onTap: () {
              _openBottomModalSheet(context: context, user: widget.currentUser);
            },
            child: const Icon(Icons.menu, color: AppColors.darkOlive),
          ),
        ),
      ],
    );
  }

  Widget buildProfileContent() {
    return Column(
      children: [
        Container(
          color: getThemeColor(context, AppColors.white, AppColors.black),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: AppColors.darkOlive,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: profileWidget(
                            imageUrl: widget.currentUser.profileUrl,
                            boxFit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          buildUserInfo(),
                          sizeVertical(10),
                          Text(
                            widget.currentUser.name.isEmpty
                                ? widget.currentUser.username
                                : widget.currentUser.name,
                            style: const TextStyle(
                              color: AppColors.olive,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          sizeVertical(10),
                          Text(
                            widget.currentUser.bio,
                            style: const TextStyle(color: AppColors.olive),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                sizeVertical(10),
              ],
            ),
          ),
        ),
        Expanded(child: buildUserPosts()),
      ],
    );
  }

  Widget buildUserInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [buildUserStats()],
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
        Text(value, style: Fonts.f20w600(color: AppColors.white)),
        sizeVertical(7),
        Text(label, style: Fonts.f14w400(color: AppColors.olive)),
      ],
    );
  }

  Future<List<PostModel>> fetchPosts() async {
    return await context
        .read<PostCubit>()
        .getFirstXPostsFromUser(_pageSize, widget.currentUser.uid);
  }

  Widget buildUserPosts() {
    return FutureBuilder<List<PostModel>>(
      future: fetchPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        } else {
          List<PostModel> posts = snapshot.data!;
          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            child: GridView.custom(
              shrinkWrap: true,
              gridDelegate: SliverQuiltedGridDelegate(
                crossAxisCount: 3,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                repeatPattern: QuiltedGridRepeatPattern.inverted,
                pattern: [
                  const QuiltedGridTile(2, 3),
                  const QuiltedGridTile(2, 2),
                  const QuiltedGridTile(1, 1),
                  const QuiltedGridTile(1, 1),
                  const QuiltedGridTile(1, 1),
                  const QuiltedGridTile(1, 1),
                  const QuiltedGridTile(1, 1),
                ],
              ),
              controller: _scrollController,
              childrenDelegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: GestureDetector(
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
                    ),
                  );
                },
                childCount: posts.length,
              ),
            ),
          );
        }
      },
    );
  }

  _openBottomModalSheet(
      {required BuildContext context, required UserModel user}) {
    return showModalBottomSheet(
        backgroundColor: AppColors.transparent,
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

class PostWidget extends StatelessWidget {
  final PostModel post;

  const PostWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            PageRoutes.PostDetailPage,
            arguments: post.postId,
          );
        },
        child: profileWidget(
          boxFit: BoxFit.cover,
          imageUrl: post.postImageUrl,
        ),
      ),
    );
  }
}
