import 'package:flutter/material.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/profile_widget.dart';
import 'package:travel_the_world/services/models/posts/post_model.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';
import 'package:travel_the_world/themes/app_colors.dart';

class UserList extends StatelessWidget {
  final List userList;
  final String title;

  const UserList({
    super.key,
    required this.userList,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    if (userList.isEmpty) {
      return _noFollowersWidget();
    }

    return Expanded(
      child: ListView.builder(
        itemCount: userList.length,
        itemBuilder: (context, index) {
          final singleUserData = userList[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                PageRoutes.SingleUserProfilePage,
                arguments: singleUserData.uid,
              );
            },
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: 40,
                  height: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: profileWidget(
                      imageUrl: singleUserData.profileUrl,
                    ),
                  ),
                ),
                sizeHorizontal(10),
                Row(
                  children: [
                    Text(
                      singleUserData.username,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _noFollowersWidget() {
    return Center(
      child: Text(
        "No ${title.toLowerCase()}",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class FollowingPageHelper extends StatelessWidget {
  final UserModel user;
  final String title;

  const FollowingPageHelper({
    super.key,
    required this.user,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getThemeColor(context, AppColors.white, AppColors.black),
      appBar: AppBar(
        title: Text(title),
        backgroundColor:
            getThemeColor(context, AppColors.white, AppColors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(
          children: [
            UserList(
              userList: user.following,
              title: title,
            ),
          ],
        ),
      ),
    );
  }
}

class LikesListPageHelper extends StatelessWidget {
  final String title;
  final PostModel post;

  const LikesListPageHelper({
    super.key,
    required this.post,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getThemeColor(context, AppColors.white, AppColors.black),
      appBar: AppBar(
        title: Text(title),
        backgroundColor:
            getThemeColor(context, AppColors.white, AppColors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(
          children: [
            UserList(
              userList: post.likes,
              title: title,
            ),
          ],
        ),
      ),
    );
  }
}

class FollowersPageHelper extends StatelessWidget {
  final String title;
  final UserModel user;

  const FollowersPageHelper({
    super.key,
    required this.user,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getThemeColor(context, AppColors.white, AppColors.black),
      appBar: AppBar(
        title: Text(title),
        backgroundColor:
            getThemeColor(context, AppColors.white, AppColors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(
          children: [
            UserList(
              userList: user.followers,
              title: title,
            ),
          ],
        ),
      ),
    );
  }
}
