import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/cubit/post/post_cubit.dart';
import 'package:travel_the_world/UI/home/widgets/single_post_card_widget.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';
import 'package:travel_the_world/themes/app_colors.dart';
import 'package:travel_the_world/themes/app_fonts.dart';

class HomePage extends StatefulWidget {
  final UserModel currentUser;
  const HomePage({super.key, required this.currentUser});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    context.read<PostCubit>().getPosts();
    return Scaffold(
      backgroundColor: getBackgroundColor(context),
      appBar: const CustomAppBar(),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, postState) {
          if (postState is PostEmpty) {
            return Center(
                child: Text(
              "No posts, yet",
              style: Fonts.f18w700(color: AppColors.black),
            ));
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
          if (postState is PostLoaded) {
            return ListView.separated(
                itemCount: postState.posts.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(height: 10),
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
    return AppBar(
      backgroundColor: getBackgroundColor(context),
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
          icon: const Icon(
            Icons.message_outlined,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
