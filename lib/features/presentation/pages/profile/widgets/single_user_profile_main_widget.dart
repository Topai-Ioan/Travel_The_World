import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/features/domain/entites/post/post_entity.dart';
import 'package:travel_the_world/features/domain/entites/user/user_entity.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/user/get_current_user_id_usecase.dart';
import 'package:travel_the_world/features/presentation/cubit/auth/auth_cubit.dart';
import 'package:travel_the_world/features/presentation/cubit/post/post_cubit.dart';
import 'package:travel_the_world/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:travel_the_world/profile_widget.dart';
import 'package:travel_the_world/injection_container.dart' as di;

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

  @override
  void initState() {
    BlocProvider.of<GetSingleUserCubit>(context)
        .getSingleUser(uid: widget.otherUserId);
    BlocProvider.of<PostCubit>(context).getPosts(post: const PostEntity());
    super.initState();

    di.sl<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
        builder: (context, userState) {
      if (userState is GetSingleUserLoaded) {
        final singleUser = userState.user;
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            title: Text("${singleUser.username}",
                style: const TextStyle(color: primaryColor)),
            actions: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: InkWell(
                  onTap: () {
                    _openBottomModalSheet(context, singleUser);
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
                          child: profileWidget(imageUrl: singleUser.profileUrl),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text('${singleUser.totalPosts}',
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
                          Column(
                            children: [
                              Text('${singleUser.totalFollowers}',
                                  style: const TextStyle(
                                      color: primaryColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              sizeVertical(7),
                              const Text(
                                'Followers',
                                style: TextStyle(color: primaryColor),
                              ),
                            ],
                          ),
                          sizeHorizontal(25),
                          Column(
                            children: [
                              Text('${singleUser.totalFollowing}',
                                  style: const TextStyle(
                                      color: primaryColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              sizeVertical(7),
                              const Text(
                                'Following',
                                style: TextStyle(color: primaryColor),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  sizeVertical(10),
                  Text(
                    '${singleUser.name == '' ? singleUser.username : singleUser.name}',
                    style: const TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                  sizeVertical(10),
                  Text(
                    '${singleUser.bio}',
                    style: const TextStyle(color: primaryColor),
                  ),
                  sizeVertical(10),
                  BlocBuilder<PostCubit, PostState>(
                    builder: (context, postState) {
                      if (postState is PostLoaded) {
                        final posts = postState.posts
                            .where(
                                (post) => post.creatorUid == widget.otherUserId)
                            .toList();
                        return GridView.builder(
                            itemCount: posts.length,
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, PageRoutes.PostDetailPage,
                                      arguments: posts[index].postId);
                                },
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: profileWidget(
                                      imageUrl: posts[index].postImageUrl),
                                ),
                              );
                            });
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        );
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }

  _openBottomModalSheet(BuildContext context, UserEntity singleUser) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent.withOpacity(0.5),
      context: context,
      builder: (context) {
        return _ModalContent(user: singleUser);
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
      height: 150,
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
