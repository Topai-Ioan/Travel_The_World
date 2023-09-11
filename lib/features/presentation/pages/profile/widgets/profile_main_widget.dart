import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/features/domain/entites/post/post_entity.dart';
import 'package:travel_the_world/features/domain/entites/user/user_entity.dart';
import 'package:travel_the_world/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:travel_the_world/features/presentation/cubit/post/post_cubit.dart';
import 'package:travel_the_world/profile_widget.dart';

class ProfileMainWidget extends StatefulWidget {
  final UserEntity currentUser;
  const ProfileMainWidget({Key? key, required this.currentUser})
      : super(key: key);

  @override
  State<ProfileMainWidget> createState() => _ProfileMainWidgetState();
}

class _ProfileMainWidgetState extends State<ProfileMainWidget> {
  @override
  void initState() {
    BlocProvider.of<PostCubit>(context).getPosts(post: const PostEntity());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text("${widget.currentUser.username}",
            style: const TextStyle(color: primaryColor)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: InkWell(
              onTap: () {
                _openBottomModalSheet(context);
              },
              child: const Icon(Icons.menu, color: primaryColor),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: profileWidget(
                          imageUrl: widget.currentUser.profileUrl),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text('${widget.currentUser.totalPosts}',
                              style: const TextStyle(
                                  color: primaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          sizeVertical(7),
                          const Text('Posts',
                              style: TextStyle(color: primaryColor))
                        ],
                      ),
                      sizeHorizontal(25),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, PageRoutes.FollowersPage,
                              arguments: widget.currentUser);
                        },
                        child: Column(
                          children: [
                            Text(
                              "${widget.currentUser.totalFollowers}",
                              style: const TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            sizeVertical(8),
                            const Text(
                              "Followers",
                              style: TextStyle(color: primaryColor),
                            )
                          ],
                        ),
                      ),
                      sizeHorizontal(25),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, PageRoutes.FollowingPage,
                              arguments: widget.currentUser);
                        },
                        child: Column(
                          children: [
                            Text(
                              "${widget.currentUser.totalFollowing}",
                              style: const TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            sizeVertical(8),
                            const Text(
                              "Following",
                              style: TextStyle(color: primaryColor),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
              sizeVertical(10),
              Text(
                '${widget.currentUser.name == '' ? widget.currentUser.username : widget.currentUser.name}',
                style: const TextStyle(
                    color: primaryColor, fontWeight: FontWeight.bold),
              ),
              sizeVertical(10),
              Text(
                '${widget.currentUser.bio}',
                style: const TextStyle(color: primaryColor),
              ),
              sizeVertical(10),
              BlocBuilder<PostCubit, PostState>(
                builder: (context, postState) {
                  if (postState is PostLoaded) {
                    final posts = postState.posts
                        .where((element) =>
                            element.creatorUid == widget.currentUser.uid)
                        .toList();
                    return GridView.builder(
                      itemCount: posts.length,
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, PageRoutes.PostDetailPage,
                              arguments: posts[index].postId),
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: profileWidget(
                              imageUrl: posts[index].postImageUrl,
                            ),
                          ),
                        );
                      },
                    );
                  } else if (postState is PostEmpty) {
                    return const Center(
                      child: Text("No post yet",
                          style: TextStyle(color: primaryColor)),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _openBottomModalSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent.withOpacity(0.5),
      context: context,
      builder: (context) {
        return _ModalContent(user: widget.currentUser);
      },
    );
  }
}

class _ModalContent extends StatelessWidget {
  final UserEntity user;

  const _ModalContent({Key? key, required this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent.withOpacity(0.5),
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _OptionItem(
                text: "Settings",
                onTap: () {},
              ),
              const SizedBox(height: 8),
              const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              const SizedBox(height: 8),
              _OptionItem(
                text: "Edit Profile",
                onTap: () {
                  Navigator.pushNamed(context, PageRoutes.EditProfilePage,
                      arguments: user);
                },
              ),
              const SizedBox(height: 7),
              const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              const SizedBox(height: 7),
              _OptionItem(
                text: "Logout",
                onTap: () {
                  BlocProvider.of<AuthCubit>(context).loggedOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, PageRoutes.SignInPage, (route) => false);
                },
              ),
              const SizedBox(height: 7),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionItem extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _OptionItem({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Text(
          text,
          style: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
