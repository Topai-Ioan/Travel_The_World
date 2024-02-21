import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/services/models/posts/post_model.dart';
import 'package:travel_the_world/profile_widget.dart';

class PostDisplayWidget extends StatefulWidget {
  final List<PostModel> posts;

  const PostDisplayWidget({super.key, required this.posts});

  @override
  PostDisplayWidgetState createState() => PostDisplayWidgetState();
}

class PostDisplayWidgetState extends State<PostDisplayWidget> {
  final ScrollController _scrollController = ScrollController();
  List<PostModel> _displayedPosts = [];
  final int _pageSize = 8;

  @override
  void initState() {
    super.initState();
    _displayedPosts = widget.posts.take(_pageSize).toList();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.position.pixels) {
      _loadMorePosts();
    }
  }

  void _loadMorePosts() {
    final int remainingPostsCount =
        widget.posts.length - _displayedPosts.length;

    if (remainingPostsCount > 0) {
      final int postsToAdd = min(remainingPostsCount, _pageSize);
      List<PostModel> newPosts = widget.posts
          .getRange(
            _displayedPosts.length,
            _displayedPosts.length + postsToAdd,
          )
          .toList();

      setState(() {
        _displayedPosts.addAll(newPosts);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.custom(
      gridDelegate: SliverQuiltedGridDelegate(
        crossAxisCount: 3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        repeatPattern: QuiltedGridRepeatPattern.inverted,
        pattern: [
          const QuiltedGridTile(2, 3),
          const QuiltedGridTile(2, 2),
          const QuiltedGridTile(1, 1),
          const QuiltedGridTile(1, 1),
          const QuiltedGridTile(1, 1),
          const QuiltedGridTile(1, 1),
          const QuiltedGridTile(1, 1),
        ],
      ),
      controller: _scrollController,
      childrenDelegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return PostWidget(post: _displayedPosts[index]);
        },
        childCount: _displayedPosts.length,
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  final PostModel post;

  const PostWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            PageRoutes.PostDetailPage,
            arguments: post.postId,
          );
        },
        child: profileWidget(
          boxFit: BoxFit.cover,
          imageUrl: post.postImageUrl,
        ),
      ),
    );
  }
}
