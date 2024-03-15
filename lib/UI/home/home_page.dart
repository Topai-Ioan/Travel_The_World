import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/UI/home/home_page_main_widget.dart';
import 'package:travel_the_world/cubit/post/home_page_posts/home_page_posts_cubit.dart';
import 'package:travel_the_world/services/firestore/posts/post_service_interface.dart';
import 'package:travel_the_world/services/models/users/user_model.dart';
import 'package:travel_the_world/injection_container.dart' as di;

class HomePage extends StatelessWidget {
  final UserModel currentUser;

  const HomePage({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          HomePagePostsCubit(postService: di.sl<PostServiceInterface>()),
      child: HomePageMainWidget(currentUser: currentUser),
    );
  }
}
