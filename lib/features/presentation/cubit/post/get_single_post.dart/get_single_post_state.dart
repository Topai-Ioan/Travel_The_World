part of 'get_single_post_cubit.dart';

abstract class GetSinglePostState extends Equatable {
  const GetSinglePostState();
  @override
  List<Object> get props => [];
}

class GetSinglePostInitial extends GetSinglePostState {}

class GetSinglePostLoading extends GetSinglePostState {}

class GetSinglePostLoaded extends GetSinglePostState {
  final PostEntity post;

  const GetSinglePostLoaded({required this.post});
}

class GetSinglePostFailure extends GetSinglePostState {}
