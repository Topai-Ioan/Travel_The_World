import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/features/presentation/cubit/post/post_cubit.dart';
import 'package:travel_the_world/features/presentation/pages/search/widgets/search_main_widget.dart';
import 'package:travel_the_world/injection_container.dart' as di;

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SearchMainWidget();
    // return MultiBlocProvider(
    //   providers: [
    //     BlocProvider<PostCubit>.value(
    //       value: di.sl<PostCubit>(),
    //     ),
    //   ],
    //   child: const SearchMainWidget(),
    // );
  }
}
