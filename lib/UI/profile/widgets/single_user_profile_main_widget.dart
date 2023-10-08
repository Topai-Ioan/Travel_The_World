import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/cubit/post/post_cubit.dart';
import 'package:travel_the_world/cubit/user/get_single_other_user/get_single_other_user_cubit.dart';
import 'package:travel_the_world/cubit/user/user_cubit.dart';
import 'package:travel_the_world/UI/shared_items/button_container_widget.dart';
import 'package:travel_the_world/profile_widget.dart';
import 'package:travel_the_world/services/auth_service.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';

class SingleUserProfileMainWidget extends StatefulWidget {
  final String otherUserId;

  const SingleUserProfileMainWidget({Key? key, required this.otherUserId})
      : super(key: key);

  @override
  State<SingleUserProfileMainWidget> createState() =>
      _SingleUserProfileMainWidgetState();
}

class _SingleUserProfileMainWidgetState
    extends State<SingleUserProfileMainWidget> {
  String _currentUid = "";
  bool _dataLoaded = false;

  @override
  void initState() {
    super.initState();
    loadData();
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
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: backgroundColor,
              title: Text(singleUser.username,
                  style: const TextStyle(color: primaryColor)),
            ),
            body: buildProfileContent(singleUser),
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
            const Divider(height: 20, thickness: 5, color: darkGreyColor),
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

  Widget showFollowUnfollowButton(UserModel singleUser) {
    return ButtonContainerWidget(
      text: singleUser.followers.contains(_currentUid) ? "UnFollow" : "Follow",
      color: singleUser.followers.contains(_currentUid)
          ? secondaryColor.withOpacity(.4)
          : blueColor,
      onTapListener: () {
        BlocProvider.of<UserCubit>(context).followUnFollowUser(
          user: UserModel(
            uid: widget.otherUserId,
          ),
        );
      },
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
}
