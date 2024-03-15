import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/cubit/post/home_page_posts/home_page_posts_cubit.dart';
import 'package:travel_the_world/UI/home/widgets/single_post_card_widget.dart';
import 'package:travel_the_world/services/models/posts/post_model.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';
import 'package:travel_the_world/themes/app_colors.dart';
import 'package:travel_the_world/themes/app_fonts.dart';
import 'dart:developer';

import 'widgets/post_loading_widget.dart';

class HomePageMainWidget extends StatefulWidget {
  final UserModel currentUser;
  const HomePageMainWidget({super.key, required this.currentUser});

  @override
  State<HomePageMainWidget> createState() => _HomePageMainWidgetState();
}

class _HomePageMainWidgetState extends State<HomePageMainWidget> {
  static const _pageSize = 10;

  final PagingController<int, PostModel> _pagingController =
      PagingController(firstPageKey: 0);
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchPage(0);
    });

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final postCubit = context.read<HomePagePostsCubit>();
      if (pageKey == 0) {
        final newItems = await postCubit.getFirstXPosts(_pageSize);
        log("newItems: $newItems");
        if (newItems.length < _pageSize) {
          _pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          _pagingController.appendPage(newItems, nextPageKey);
        }
      } else {
        final lastPostId = _pagingController.itemList!.last.postId;
        final lastReference = postCubit.getPostReference(lastPostId);
        if (lastReference == null) {
          return;
        }
        final lastSnapshot = await lastReference.get();
        final newItems = await postCubit.getMorePosts(_pageSize, lastSnapshot);
        final isLastPage = newItems.length < _pageSize;
        if (isLastPage) {
          _pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          _pagingController.appendPage(newItems, nextPageKey);
        }
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getBackgroundColor(context),
      appBar: const CustomAppBar(),
      body: BlocBuilder<HomePagePostsCubit, HomePagePostsState>(
        builder: (context, postState) {
          switch (postState) {
            case HomePagePostsInitial():
              log("HomePagePostsInitial");
              return const PostLoadingWidget();
            case HomePagePostsEmpty():
              log("HomePagePostsEmpty");
              return Center(
                  child: Text(
                "No posts, yet",
                style: Fonts.f18w700(color: AppColors.black),
              ));
            case HomePagePostsFailure():
              log("HomePagePostsFailure");
              toast("some error occur");
            case HomePagePostsLoading():
              log("HomePagePostsLoading");
              return const PostLoadingWidget();
            case HomePagePostsLoaded():
              log("HomePagePostsLoaded");
              return PostListView(
                pagingController: _pagingController,
                currentUser: widget.currentUser,
              );
          }
          return const Center(child: Text("some error occur"));
        },
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: getBackgroundColor(context),
      surfaceTintColor: getBackgroundColor(context),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/logo.png",
            height: 30,
          ),
          Text(
            "Travel the world",
            style: Fonts.f20w700(color: getTextColor(context)),
          ),
          sizeVertical(15),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.message_outlined,
            color: getTextColor(context),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class PostListView extends StatelessWidget {
  final PagingController<int, PostModel> pagingController;
  final UserModel currentUser;

  const PostListView(
      {super.key, required this.pagingController, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, PostModel>(
      pagingController: pagingController,
      builderDelegate: PagedChildBuilderDelegate<PostModel>(
          itemBuilder: (context, post, index) {
            return SinglePostCardWidget(
              currentUserId: currentUser.uid,
              post: post,
            );
          },
          newPageProgressIndicatorBuilder: (context) => Container()),
    );
  }
}
