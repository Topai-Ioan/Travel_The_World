part of 'comment_cubit.dart';

abstract class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object> get props => [];
}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentLoaded extends CommentState {
  final List<CommentModel> comments;

  const CommentLoaded({required this.comments});
  @override
  List<Object> get props => [comments];
}

class CommentFailure extends CommentState {}

class CommentEmpty extends CommentState {}
