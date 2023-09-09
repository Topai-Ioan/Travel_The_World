part of 'post_cubit.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<PostEntity> posts;

  const PostLoaded({required this.posts});
  @override
  List<Object> get props => [posts];
}

class PostFailure extends PostState {}

class PostEmpty extends PostState {}
