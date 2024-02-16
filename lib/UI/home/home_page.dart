import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/cubit/post/post_cubit.dart';
import 'package:travel_the_world/UI/home/widgets/single_post_card_widget.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';

class HomePage extends StatefulWidget {
  final UserModel currentUser;
  const HomePage({super.key, required this.currentUser});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    context
        .read<PostCubit>()
        .getPostsFromFollowingUsersInTheLast24h(widget.currentUser);
    final theme = Theme.of(context);
    final backgroundColor = theme.colorScheme.background;
    final primaryColor = theme.colorScheme.primary;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const CustomAppBar(),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, postState) {
          if (postState is PostEmpty) {
            return Center(
              child: Text("No posts, yet",
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            );
          }
          if (postState is PostLoading) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 15, maxWidth: 15),
                child: const CircularProgressIndicator(),
              ),
            );
          }
          if (postState is PostFailure) {
            toast("some error occur");
          }
          if (postState is PostLoadedInTheLast24h) {
            return ListView.builder(
                itemCount: postState.posts.length,
                itemBuilder: (context, index) {
                  final post = postState.posts[index];
                  return SinglePostCardWidget(
                    currentUserId: widget.currentUser.uid,
                    post: post,
                  );
                });
          }
          return const Center(
            child: SizedBox(
                height: 15, width: 15, child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = AppBarTheme.of(context).backgroundColor;
    final primaryColor = theme.colorScheme.primary;

    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/logo.png",
            height: 30,
          ),
          Text(
            "Travel the world",
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.message_outlined,
            color: primaryColor,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
