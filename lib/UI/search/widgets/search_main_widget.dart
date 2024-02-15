import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/UI/search/widgets/category_search_results_widget.dart';
import 'package:travel_the_world/UI/search/widgets/post_display_widget.dart';
import 'package:travel_the_world/UI/search/widgets/searchbar_widget.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/cubit/post/post_cubit.dart';
import 'package:travel_the_world/cubit/user/user_cubit.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';
import 'package:travel_the_world/profile_widget.dart';

class SearchMainWidget extends StatefulWidget {
  const SearchMainWidget({super.key});

  @override
  State<SearchMainWidget> createState() => _SearchMainWidgetState();
}

class _SearchMainWidgetState extends State<SearchMainWidget> {
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<bool> _showUsersNotifier = ValueNotifier<bool>(true);
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    context.read<PostCubit>().getPosts();
    context.read<UserCubit>().getUsers(user: UserModel());

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _showUsersNotifier.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (_showUsersNotifier.value) {
        context.read<UserCubit>().getUsers(user: UserModel());
      } else {
        if (_searchController.text.isNotEmpty) {
          context.read<PostCubit>().getPostsFiltered(_searchController.text);
        } else {
          context.read<PostCubit>().getPosts();
        }
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, userState) {
          if (userState is UsersLoaded) {
            final searchText = _searchController.text.toLowerCase();
            final filterAllUsers = userState.users
                .where((user) =>
                    user.username.toLowerCase().startsWith(searchText))
                .toList();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchBarWidget(controller: _searchController),
                  _searchController.text.isNotEmpty
                      ? CategorySearchResultsWidget(
                          filterAllUsers: filterAllUsers,
                          filterText: _searchController.text,
                          showUsersNotifier: _showUsersNotifier,
                        )
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
    );
  }
}

class GetFilteredPosts extends StatelessWidget {
  final String filterText;

  const GetFilteredPosts({
    super.key,
    required this.filterText,
  });

  @override
  Widget build(BuildContext context) {
    context.read<PostCubit>().getPostsFiltered(filterText);
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<PostCubit>().getPostsFiltered(filterText);
        },
        child: BlocBuilder<PostCubit, PostState>(
          builder: (context, postState) {
            if (postState is PostLoading) {
              return const CircularProgressIndicator();
            }
            if (postState is FilteredPostsLoaded) {
              final posts = postState.posts;
              return PostDisplayWidget(posts: posts);
            }
            return const Text(
              'No data found!',
              style: TextStyle(color: Colors.blue),
            );
          },
        ),
      ),
    );
  }
}

class GetAllPosts extends StatelessWidget {
  const GetAllPosts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<PostCubit>().getPosts();
        },
        child: BlocBuilder<PostCubit, PostState>(
          builder: (context, postState) {
            if (postState is PostLoading) {
              return const CircularProgressIndicator();
            }
            if (postState is PostLoaded) {
              final posts = postState.posts;
              return PostDisplayWidget(posts: posts);
            }
            return const Text(
              'No data found!',
              style: TextStyle(color: Colors.green),
            );
          },
        ),
      ),
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
