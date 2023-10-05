import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/features/presentation/cubit/post/post_cubit.dart';
import 'package:travel_the_world/features/presentation/pages/post/post/widgets/upload_post_main_widget.dart';
import 'package:travel_the_world/injection_container.dart' as di;
import 'package:travel_the_world/services/models/users/user_model.dart';

class UploadPostPage extends StatelessWidget {
  final UserModel currentUser;

  const UploadPostPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCubit>.value(
      value: di.sl<PostCubit>(),
      child: UploadPostMainWidget(currentUser: currentUser),
    );
  }
}
