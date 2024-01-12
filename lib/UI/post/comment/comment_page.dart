import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/services/models/app_entity.dart';
import 'package:travel_the_world/cubit/comment/comment_cubit.dart';
import 'package:travel_the_world/UI/post/comment/widgets/comment_main_widget.dart';
import 'package:travel_the_world/injection_container.dart' as di;

class CommentPage extends StatelessWidget {
  final AppEntity appEntity;
  const CommentPage({Key? key, required this.appEntity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommentCubit>.value(
      value: di.sl<CommentCubit>(),
      child: CommentMainWidget(appEntity: appEntity),
    );
  }
}
