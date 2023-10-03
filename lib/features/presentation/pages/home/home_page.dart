import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/features/domain/entites/user/user_entity.dart';
import 'package:travel_the_world/features/presentation/cubit/post/post_cubit.dart';
import 'package:travel_the_world/features/presentation/pages/home/widgets/single_post_card_widget.dart';
import 'package:travel_the_world/injection_container.dart' as di;

class HomePage extends StatefulWidget {
  final UserEntity currentUser;
  const HomePage({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: appBarColor,
          elevation: 0,
          title: Image.asset(
            "assets/images/logo.png",
            height: 30,
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.message_outlined,
                color: primaryColor,
              ),
            ),
          ],
        ),
        body: BlocProvider.value(
          value: di.sl<PostCubit>()
            ..getPostsFromFollowingUsers(widget.currentUser),
          child:
              BlocBuilder<PostCubit, PostState>(builder: (context, postState) {
            if (postState is PostEmpty) {
              return const Center(
                child: Text("no posts",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              );
            }
            if (postState is PostLoading) {
              return Center(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxHeight: 15, maxWidth: 15),
                  child: const CircularProgressIndicator(),
                ),
              );
            }
            if (postState is PostFailure) {
              toast("some error occur");
            }
            if (postState is PostLoaded) {
              return ListView.builder(
                  itemCount: postState.posts.length,
                  itemBuilder: (context, index) {
                    final post = postState.posts[index];
                    return SinglePostCardWidget(
                        post: post,
                        postCubit: BlocProvider.of<PostCubit>(context));
                  });
            }
            return const Center(
              child: SizedBox(
                  height: 15, width: 15, child: CircularProgressIndicator()),
            );
          }),
        ));
  }
}
