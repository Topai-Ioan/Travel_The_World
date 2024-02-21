import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/cubit/comment/comment_cubit.dart';
import 'package:travel_the_world/UI/post/comment/widgets/edit_comment_main_widget.dart';
import 'package:travel_the_world/injection_container.dart' as di;
import 'package:travel_the_world/services/models/comments/comment_model.dart';

class EditCommentPage extends StatelessWidget {
  final CommentModel comment;

  const EditCommentPage({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommentCubit>(
      create: (context) => di.sl<CommentCubit>(),
      child: EditCommentMainWidget(comment: comment),
    );
  }
}
