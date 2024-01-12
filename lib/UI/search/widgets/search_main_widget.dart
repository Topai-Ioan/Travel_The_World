import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/cubit/post/post_cubit.dart';
import 'package:travel_the_world/cubit/user/user_cubit.dart';
import 'package:travel_the_world/UI/search/widgets/search_widget.dart';
import 'package:travel_the_world/profile_widget.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';

class SearchMainWidget extends StatefulWidget {
  const SearchMainWidget({Key? key}) : super(key: key);

  @override
  State<SearchMainWidget> createState() => _SearchMainWidgetState();
}

class _SearchMainWidgetState extends State<SearchMainWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserCubit>(context).getUsers(user: UserModel());

    BlocProvider.of<PostCubit>(context).getPosts();

    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textScheme = Theme.of(context).textTheme;
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () {
          if (_searchController.text.isEmpty) {
            _refreshPage(context);
          }
          return Future.value();
        },
        child: Scaffold(
          backgroundColor: colorScheme.background,
          body: BlocBuilder<UserCubit, UserState>(
            builder: (context, userState) {
              if (userState is UsersLoaded) {
                final searchText = _searchController.text.toLowerCase();
                final filterAllUsers = userState.users
                    .where((user) =>
                        user.username.toLowerCase().startsWith(searchText) ||
                        user.username.toLowerCase().contains(searchText))
                    .toList();
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SearchWidget(controller: _searchController),
                      sizeVertical(10),
                      _searchController.text.isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                itemCount: filterAllUsers.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context,
                                          PageRoutes.SingleUserProfilePage,
                                          arguments: filterAllUsers[index].uid);
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          width: 40,
                                          height: 40,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: profileWidget(
                                                imageUrl: filterAllUsers[index]
                                                    .profileUrl),
                                          ),
                                        ),
                                        sizeHorizontal(10),
                                        Text(
                                          filterAllUsers[index].username,
                                          style: textScheme.bodyMedium,
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          : BlocBuilder<PostCubit, PostState>(
                              builder: (context, postState) {
                                if (postState is PostLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (postState is PostLoaded) {
                                  final posts = postState.posts;
                                  return Expanded(
                                    child: GridView.builder(
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
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                PageRoutes.PostDetailPage,
                                                arguments: posts[index].postId);
                                          },
                                          child: SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: profileWidget(
                                                boxFit: BoxFit.cover,
                                                imageUrl:
                                                    posts[index].postImageUrl),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                                return const Text(
                                  'No data found!',
                                  style: TextStyle(color: Colors.red),
                                );
                              },
                            ),
                    ],
                  ),
                );
              }
              return Center(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxHeight: 15, maxWidth: 15),
                  child: const CircularProgressIndicator(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

Future<void> _refreshPage(BuildContext context) async {
  BlocProvider.of<UserCubit>(context).getUsers(user: UserModel());
  BlocProvider.of<PostCubit>(context).getPosts();
}
