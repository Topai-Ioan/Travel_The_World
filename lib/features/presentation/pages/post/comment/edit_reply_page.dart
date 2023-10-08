import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_the_world/features/presentation/cubit/reply/reply_cubit.dart';
import 'package:travel_the_world/features/presentation/pages/post/comment/widgets/edit_reply_main_widget.dart';
import 'package:travel_the_world/injection_container.dart' as di;
import 'package:travel_the_world/services/models/replies/reply_model.dart';

class EditReplyPage extends StatelessWidget {
  final ReplyModel reply;

  const EditReplyPage({Key? key, required this.reply}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReplyCubit>.value(
      value: di.sl<ReplyCubit>(),
      child: EditReplyMainWidget(reply: reply),
    );
  }
}
