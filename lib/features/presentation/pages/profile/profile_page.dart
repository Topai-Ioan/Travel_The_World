import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/features/domain/entites/user/user_entity.dart';
import 'package:travel_the_world/features/presentation/cubit/post/post_cubit.dart';
import 'package:travel_the_world/features/presentation/pages/profile/widgets/profile_main_widget.dart';
import 'package:travel_the_world/injection_container.dart' as di;

class ProfilePage extends StatelessWidget {
  final UserEntity currentUser;
  const ProfilePage({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCubit>.value(
      value: di.sl<PostCubit>(),
      child: ProfileMainWidget(currentUser: currentUser),
    );
  }
}
