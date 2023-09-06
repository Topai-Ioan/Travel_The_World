import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/features/presentation/cubit/post/post_cubit.dart';
import 'package:travel_the_world/features/presentation/cubit/user/get_single_user/get_single_user_cubit.dart';
import 'package:travel_the_world/features/presentation/pages/profile/widgets/single_user_profile_main_widget.dart';
import 'package:travel_the_world/injection_container.dart' as di;

class SingleUserProfilePage extends StatelessWidget {
  final String otherUserId;
  const SingleUserProfilePage({super.key, required this.otherUserId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetSingleUserCubit>(
          create: (context) => di.sl<GetSingleUserCubit>(),
        ),
        BlocProvider<PostCubit>.value(
          value: di.sl<PostCubit>(),
        ),
      ],
      child: SingleUserProfileMainWidget(
        otherUserId: otherUserId,
      ),
    );
  }
}
