import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/cubit/post/post_cubit.dart';
import 'package:travel_the_world/UI/post/post/upload/upload_post_main_widget.dart';
import 'package:travel_the_world/injection_container.dart' as di;
import 'package:travel_the_world/services/models/users/user_model.dart';

class UploadPostPage extends StatelessWidget {
  final UserModel currentUser;

  const UploadPostPage({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCubit>.value(
      value: di.sl<PostCubit>(),
      child: UploadPostMainWidget(currentUser: currentUser),
    );
  }
}
