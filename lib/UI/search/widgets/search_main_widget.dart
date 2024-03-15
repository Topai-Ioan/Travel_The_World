import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/UI/search/widgets/category_search_results_widget.dart';
import 'package:travel_the_world/UI/search/widgets/post_display_widget.dart';
import 'package:travel_the_world/UI/search/widgets/searchbar_widget.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/cubit/post/post_cubit.dart';
import 'package:travel_the_world/cubit/user/user_cubit.dart';
import 'package:travel_the_world/profile_widget.dart';
import 'package:travel_the_world/themes/app_colors.dart';
import 'package:travel_the_world/themes/app_fonts.dart';

import 'post_skeleton_widget.dart';

class SearchMainWidget extends StatefulWidget {
  const SearchMainWidget({super.key});

  @override
  State<SearchMainWidget> createState() => _SearchMainWidgetState();
}

class _SearchMainWidgetState extends State<SearchMainWidget> {
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<bool> _showUsersNotifier = ValueNotifier<bool>(true);
  Timer? _debounceTimer;
  final _searchFocusNode = FocusNode();
  String _oldFilterText = '';

  @override
  void initState() {
    super.initState();
    context.read<PostCubit>().getPosts();

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _showUsersNotifier.dispose();
    _debounceTimer?.cancel();
    _searchFocusNode.dispose();

    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 1000), () {
      if (_searchFocusNode.hasFocus &&
          _searchController.text != _oldFilterText) {
        if (_showUsersNotifier.value) {
          context.read<UserCubit>().searchUsers(_searchController.text);
        } else {
          if (_searchController.text.isNotEmpty) {
            context.read<PostCubit>().getPostsFiltered(_searchController.text);
          } else {
            context.read<PostCubit>().getPosts();
          }
        }
        _oldFilterText = _searchController.text;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SearchBarWidget(
              controller: _searchController, focusNode: _searchFocusNode),
          _searchController.text.isNotEmpty
              ? CategorySearchResultsWidget(
                  filterText: _searchController.text.toLowerCase(),
                  showUsersNotifier: _showUsersNotifier,
                )
              : const GetAllPosts()
        ],
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
            return Text(
              'No data found!',
              style: TextStyle(color: getTextColor(context)),
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
    context.read<PostCubit>().getPosts();
    return Expanded(
      child: BlocBuilder<PostCubit, PostState>(
        builder: (context, postState) {
          if (postState is PostLoading) {
            return const PostSkeletonWidget();
          }
          if (postState is PostLoaded) {
            final posts = postState.posts;
            return PostDisplayWidget(posts: posts);
          }
          return Text(
            'No data found!',
            style: TextStyle(color: getTextColor(context)),
          );
        },
      ),
    );
  }
}

class GetFilteredUsers extends StatefulWidget {
  final String filterText;

  const GetFilteredUsers({
    super.key,
    required this.filterText,
  });

  @override
  State<GetFilteredUsers> createState() {
    return _GetFilteredUsersState();
  }
}

class _GetFilteredUsersState extends State<GetFilteredUsers> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserCubit>(context).searchUsers(widget.filterText);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UsersLoaded) {
          final users = state.users;
          if (users.isEmpty) {
            return Center(
              child: Text('No users found!',
                  style: TextStyle(color: getTextColor(context))),
            );
          }
          return Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      PageRoutes.SingleUserProfilePage,
                      arguments: user.uid,
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
                            imageUrl: user.profileUrl,
                            boxFit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        user.username,
                        style: Fonts.f14w600(
                          color: getTextColor(context),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
