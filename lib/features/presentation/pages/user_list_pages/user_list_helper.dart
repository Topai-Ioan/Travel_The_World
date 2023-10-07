import 'package:flutter/material.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/profile_widget.dart';
import 'package:travel_the_world/services/firestore/users/user_service.dart';
import 'package:travel_the_world/services/models/posts/post_model.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';

class UserList extends StatelessWidget {
  final List<dynamic> userList;
  final String title;

  const UserList({
    Key? key,
    required this.userList,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userList.isEmpty) {
      return _noFollowersWidget();
    }

    return Expanded(
      child: ListView.builder(
        itemCount: userList.length,
        itemBuilder: (context, index) {
          final String userId = userList[index]; // Cast each element to String
          return StreamBuilder<List<UserModel>>(
            stream: UserService().getUser(uid: userId),
            builder: (context, snapshot) {
              if (snapshot.hasData == false) {
                return const CircularProgressIndicator();
              }
              if (snapshot.data!.isEmpty) {
                return Container();
              }
              final singleUserData = snapshot.data!.first;
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
                            color: primaryColor,
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
    Key? key,
    required this.user,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: backgroundColor,
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
    Key? key,
    required this.post,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: backgroundColor,
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
    Key? key,
    required this.user,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: backgroundColor,
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
