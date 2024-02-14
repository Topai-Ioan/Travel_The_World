import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/cubit/post/post_cubit.dart';
import 'package:travel_the_world/cubit/user/user_cubit.dart';
import 'package:travel_the_world/UI/search/widgets/search_widget.dart';
import 'package:travel_the_world/profile_widget.dart';
import 'package:travel_the_world/services/models/posts/post_model.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';

class UserSearchResultsWidget extends StatefulWidget {
  final List<UserModel> filterAllUsers;
  final String filterText;
  final VoidCallback onStateChanged; // Define the callback here

  const UserSearchResultsWidget(
      {super.key,
      required this.filterAllUsers,
      required this.onStateChanged,
      required this.filterText});

  @override
  State<UserSearchResultsWidget> createState() =>
      _UserSearchResultsWidgetState();
}

class _UserSearchResultsWidgetState extends State<UserSearchResultsWidget> {
  bool showFilteredUsers = true;
  bool showFilteredPosts = true;
  @override
  Widget build(BuildContext context) {
    void _showFilteredUsers() {
      setState(() {
        showFilteredUsers = true;
        showFilteredPosts = false;
      });
      widget.onStateChanged();
    }

    void _showFilteredPosts() {
      setState(() {
        showFilteredUsers = false;
        showFilteredPosts = true;
      });
      widget.onStateChanged();
    }

    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    _showFilteredUsers();
                  },
                  child: const Text(
                    'Users',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () {
                    _showFilteredPosts();
                  },
                  child: const Text(
                    'Photos',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (showFilteredUsers)
            GetFilteredUsers(filterAllUsers: widget.filterAllUsers)
          else if (showFilteredPosts)
            GetFilteredPosts(
              filterText: widget.filterText,
            )
        ],
      ),
    );
  }
}

class PostDisplayWidget extends StatelessWidget {
  final List<PostModel> posts;

  const PostDisplayWidget({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MasonryGridView.builder(
        itemCount: posts.length,
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(3.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    PageRoutes.PostDetailPage,
                    arguments: posts[index].postId,
                  );
                },
                child: profileWidget(
                  boxFit: BoxFit.cover,
                  imageUrl: posts[index].postImageUrl,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SearchMainWidget extends StatefulWidget {
  const SearchMainWidget({super.key});

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
    return RefreshIndicator(
      onRefresh: () {
        if (_searchController.text.isEmpty) {
          _refreshPage(context);
        }
        return Future.value();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
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
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchWidget(controller: _searchController),
                    _searchController.text.isNotEmpty
                        ? UserSearchResultsWidget(
                            filterAllUsers: filterAllUsers,
                            filterText: _searchController.text,
                            onStateChanged: () {
                              setState(() {});
                            })
                        : const GetAllPosts()
                  ],
                ),
              );
            }
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 15, maxWidth: 15),
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class GetFilteredPosts extends StatelessWidget {
  final String filterText; // Add this field to store the filter text

  const GetFilteredPosts({
    super.key,
    required this.filterText, // Initialize the filter text parameter
  });

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PostCubit>(context).getPostsFiltered(filterText);

    return BlocBuilder<PostCubit, PostState>(
      builder: (context, postState) {
        if (postState is PostLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }
        if (postState is FilteredPostsLoaded) {
          final posts = postState.posts;
          return PostDisplayWidget(posts: posts);
        }
        return const Text(
          'No data found!',
          style: TextStyle(color: Colors.red),
        );
      },
    );
  }
}

class GetAllPosts extends StatelessWidget {
  const GetAllPosts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // va trebui sa creez o metoda si sa o apelez aici care sa caute doar pozele cu metadata
    // care contine textul din searchController
    return BlocBuilder<PostCubit, PostState>(
      builder: (context, postState) {
        if (postState is PostLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }
        if (postState is PostLoaded) {
          final posts = postState.posts;
          return PostDisplayWidget(posts: posts);
        }
        return const Text(
          'No data found!',
          style: TextStyle(color: Colors.red),
        );
      },
    );
  }
}

class GetFilteredUsers extends StatelessWidget {
  final List<UserModel> filterAllUsers;

  const GetFilteredUsers({
    super.key,
    required this.filterAllUsers,
  });

  @override
  Widget build(BuildContext context) {
    if (filterAllUsers.isEmpty) {
      return const Center(
          child: Text('No users found', style: TextStyle(color: Colors.red)));
    }
    return Expanded(
      child: ListView.builder(
        itemCount: filterAllUsers.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                PageRoutes.SingleUserProfilePage,
                arguments: filterAllUsers[index].uid,
              );
            },
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  width: 40,
                  height: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: profileWidget(
                      imageUrl: filterAllUsers[index].profileUrl,
                      boxFit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  filterAllUsers[index].username,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

Future<void> _refreshPage(BuildContext context) async {
  BlocProvider.of<UserCubit>(context).getUsers(user: UserModel());
  BlocProvider.of<PostCubit>(context).getPosts();
}
