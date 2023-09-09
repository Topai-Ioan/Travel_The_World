part of 'reply_cubit.dart';

abstract class ReplyState extends Equatable {
  const ReplyState();

  @override
  List<Object> get props => [];
}

class ReplyInitial extends ReplyState {}

class ReplyLoading extends ReplyState {}

class ReplyLoaded extends ReplyState {
  final List<ReplyEntity> replies;

  const ReplyLoaded({required this.replies});

  @override
  List<Object> get props => [replies];
}

class ReplyFailure extends ReplyState {}

class ReplyEmpty extends ReplyState {}
