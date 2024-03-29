import 'package:flutter/material.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/profile_widget.dart';
import 'package:travel_the_world/services/firestore/users/user_service_interface.dart';
import 'package:travel_the_world/services/models/posts/post_model.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';
import 'package:travel_the_world/services/models/users/user_model_for_lists.dart';
import 'package:travel_the_world/themes/app_colors.dart';
import 'package:travel_the_world/injection_container.dart' as di;

class UserList extends StatefulWidget {
  final List<String> userList;
  final String title;

  const UserList({
    super.key,
    required this.userList,
    required this.title,
  });

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<UserModelForLists> usersData = [];

  @override
  void initState() {
    super.initState();
    _fetchUsersData();
  }

  Future<void> _fetchUsersData() async {
    final fetchedUsersData =
        await di.sl<UserServiceInterface>().getUsers(uids: widget.userList);
    setState(() {
      usersData = fetchedUsersData;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (usersData.isEmpty) {
      return _noFollowersWidget();
    }
    return Expanded(
      child: ListView.builder(
        itemCount: usersData.length,
        itemBuilder: (context, index) {
          final singleUserData = usersData[index];
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
        "No ${widget.title.toLowerCase()}",
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
      backgroundColor: getBackgroundColor(context),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: getBackgroundColor(context),
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
      backgroundColor: getBackgroundColor(context),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: getBackgroundColor(context),
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
      backgroundColor: getBackgroundColor(context),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: getBackgroundColor(context),
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
