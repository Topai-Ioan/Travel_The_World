import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/cubit/post/post_cubit.dart';
import 'package:travel_the_world/UI/post/post/widgets/update_post_main_widget.dart';
import 'package:travel_the_world/injection_container.dart' as di;
import 'package:travel_the_world/services/models/posts/post_model.dart';

class UpdatePostPage extends StatefulWidget {
  final PostModel post;
  const UpdatePostPage({super.key, required this.post});

  @override
  State<UpdatePostPage> createState() => _UpdatePostPageState();
}

class _UpdatePostPageState extends State<UpdatePostPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCubit>.value(
      value: di.sl<PostCubit>(),
      child: UpdatePostMainWidget(post: widget.post),
    );
  }
}
