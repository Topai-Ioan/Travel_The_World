import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/features/domain/entites/post/post_entity.dart';
import 'package:travel_the_world/features/domain/entites/user/user_entity.dart';
import 'package:travel_the_world/features/domain/usecases/firebase_usecasses/user/get_current_user_id_usecase.dart';
import 'package:travel_the_world/features/presentation/cubit/post/post_cubit.dart';
import 'package:travel_the_world/features/presentation/cubit/user/get_single_other_user/get_single_other_user_cubit.dart';
import 'package:travel_the_world/features/presentation/cubit/user/user_cubit.dart';
import 'package:travel_the_world/features/presentation/pages/credential/widgets/button_container_widget.dart';
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
  bool _dataLoaded = false;

  @override
  void initState() {
    if (!_dataLoaded) {
      BlocProvider.of<GetSingleOtherUserCubit>(context)
          .getSingleOtherUser(otherUid: widget.otherUserId);
      BlocProvider.of<PostCubit>(context).getPosts();
      _dataLoaded = true; // Set the flag to true after loading data
    }

    super.initState();

    di.sl<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
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
            title: Text("${singleUser.username}",
                style: const TextStyle(color: primaryColor)),
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
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, PageRoutes.FollowersPage,
                                  arguments: singleUser);
                            },
                            child: Column(
                              children: [
                                Text(
                                  "${singleUser.totalFollowers}",
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
                              Navigator.pushNamed(
                                  context, PageRoutes.FollowingPage,
                                  arguments: singleUser);
                            },
                            child: Column(
                              children: [
                                Text(
                                  "${singleUser.totalFollowing}",
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
                  _currentUid == singleUser.uid
                      ? Container()
                      : ButtonContainerWidget(
                          text: singleUser.followers!.contains(_currentUid)
                              ? "UnFollow"
                              : "Follow",
                          color: singleUser.followers!.contains(_currentUid)
                              ? secondaryColor.withOpacity(.4)
                              : blueColor,
                          onTapListener: () {
                            BlocProvider.of<UserCubit>(context)
                                .followUnFollowUser(
                                    user: UserEntity(
                                        uid: _currentUid,
                                        otherUid: widget.otherUserId));
                          },
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
}
