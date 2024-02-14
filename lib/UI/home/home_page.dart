import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/constants.dart';
import 'package:travel_the_world/cubit/post/post_cubit.dart';
import 'package:travel_the_world/UI/home/widgets/single_post_card_widget.dart';
import 'package:travel_the_world/injection_container.dart' as di;
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
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: AppBarTheme.of(context).backgroundColor,
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
                  color: Theme.of(context).colorScheme.primary,
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
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
        body: BlocProvider.value(
          value: di.sl<PostCubit>()
            ..getPostsFromFollowingUsersInTheLast24h(widget.currentUser),
          child:
              BlocBuilder<PostCubit, PostState>(builder: (context, postState) {
            if (postState is PostEmpty) {
              return Center(
                child: Text("No posts, yet",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
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
