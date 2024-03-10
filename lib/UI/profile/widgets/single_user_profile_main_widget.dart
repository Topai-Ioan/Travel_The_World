import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/UI/main_screen/main_screen.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/cubit/post/post_cubit.dart';
import 'package:travel_the_world/cubit/user/get_single_other_user/get_single_other_user_cubit.dart';
import 'package:travel_the_world/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:travel_the_world/cubit/user/user_cubit.dart';
import 'package:travel_the_world/UI/shared_items/button_container_widget.dart';
import 'package:travel_the_world/profile_widget.dart';
import 'package:travel_the_world/services/firestore/auth/auth_service.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';
import 'package:travel_the_world/themes/app_colors.dart';
import 'package:travel_the_world/themes/app_fonts.dart';

class SingleUserProfileMainWidget extends StatefulWidget {
  final String otherUserId;

  const SingleUserProfileMainWidget({super.key, required this.otherUserId});

  @override
  State<SingleUserProfileMainWidget> createState() =>
      _SingleUserProfileMainWidgetState();
}

class _SingleUserProfileMainWidgetState
    extends State<SingleUserProfileMainWidget> {
  String _currentUid = "";
  bool _dataLoaded = false;
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetSingleUserCubit>(context)
        .getSingleUser(uid: widget.otherUserId);

    _pageController = PageController();

    loadData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigationTapped(int index) {
    _pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> loadData() async {
    if (!_dataLoaded) {
      BlocProvider.of<GetSingleOtherUserCubit>(context)
          .getSingleOtherUser(otherUid: widget.otherUserId);
      BlocProvider.of<PostCubit>(context).getPosts();
      _dataLoaded = true;
    }

    final uid = AuthService().getCurrentUserId()!;

    if (mounted) {
      setState(() {
        _currentUid = uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSingleOtherUserCubit, GetSingleOtherUserState>(
      builder: (context, userState) {
        if (userState is GetSingleOtherUserLoaded) {
          final singleUser = userState.otherUser;
          return Scaffold(
            backgroundColor: getBackgroundColor(context),
            appBar: AppBar(
              backgroundColor: getBackgroundColor(context),
              title: Text(singleUser.username,
                  style: Fonts.f20w600(color: getTextColor(context))),
            ),
            body: buildProfileContent(singleUser),
            bottomNavigationBar: CustomCupertinoTabBar(
              currentIndex: _currentIndex,
              onTap: _navigationTapped,
            ),
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

  Widget buildProfileContent(UserModel singleUser) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildUserInfo(singleUser),
            if (_currentUid != singleUser.uid)
              showFollowUnfollowButton(singleUser),
            buildUserPosts(),
          ],
        ),
      ),
    );
  }

  Widget buildUserInfo(UserModel singleUser) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: profileWidget(
                imageUrl: singleUser.profileUrl, boxFit: BoxFit.cover),
          ),
        ),
        buildUserStats(singleUser),
      ],
    );
  }

  Widget buildUserStats(UserModel singleUser) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildStat("Posts", singleUser.totalPosts.toString()),
        sizeHorizontal(25),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, PageRoutes.FollowersPage,
                arguments: singleUser);
          },
          child: buildStat("Followers", "${singleUser.followers.length}"),
        ),
        sizeHorizontal(25),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, PageRoutes.FollowingPage,
                arguments: singleUser);
          },
          child: buildStat("Following", "${singleUser.following.length}"),
        ),
      ],
    );
  }

  Widget buildStat(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: Fonts.f20w700(
                color:
                    getThemeColor(context, AppColors.black, AppColors.white))),
        sizeVertical(7),
        Text(label,
            style: Fonts.f16w400(
                color: getThemeColor(
                    context, AppColors.darkOlive, AppColors.olive))),
      ],
    );
  }

  Widget showFollowUnfollowButton(UserModel singleUser) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ButtonContainerWidget(
        backgroundColor: AppColors.darkOlive,
        textStyle: Fonts.f18w600(
          color: singleUser.followers.contains(_currentUid)
              ? AppColors.olive
              : AppColors.white,
        ),
        text:
            singleUser.followers.contains(_currentUid) ? "Unfollow" : "Follow",
        onTapListener: () {
          BlocProvider.of<UserCubit>(context).followUnFollowUser(
            user: UserModel(
              uid: widget.otherUserId,
            ),
          );
        },
      ),
    );
  }

  Widget buildUserPosts() {
    return BlocBuilder<PostCubit, PostState>(
      builder: (context, postState) {
        if (postState is PostLoaded) {
          final posts = postState.posts
              .where((post) => post.creatorUid == widget.otherUserId)
              .toList();
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
            child: GridView.builder(
                itemCount: posts.length,
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemBuilder: (context, index) {
                  final postImage = GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        PageRoutes.PostDetailPage,
                        arguments: posts[index].postId,
                      );
                    },
                    child: SizedBox(
                      width: 175,
                      height: 175,
                      child: profileWidget(
                        imageUrl: posts[index].postImageUrl,
                      ),
                    ),
                  );

                  return Column(
                    children: [
                      postImage,
                    ],
                  );
                }),
          );
        }
        if (postState is PostEmpty) {
          return Center(
            child: Text("No post yet", style: Fonts.f18w700(color: Colors.red)),
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
}
