part of 'reply_cubit.dart';

abstract class ReplyState extends Equatable {
  const ReplyState();

  @override
  List<Object> get props => [];
}

class ReplyInitial extends ReplyState {
  @override
  List<Object> get props => [];
}

class ReplyLoading extends ReplyState {
  @override
  List<Object> get props => [];
}

class ReplyLoaded extends ReplyState {
  final List<ReplyEntity> replies;

  ReplyLoaded({required this.replies});

  @override
  List<Object> get props => [replies];
}

class ReplyFailure extends ReplyState {
  @override
  List<Object> get props => [];
}

class ReplyEmpty extends ReplyState {
  @override
  List<Object> get props => [];
}
