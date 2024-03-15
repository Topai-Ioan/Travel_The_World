part of 'home_page_posts_cubit.dart';

sealed class HomePagePostsState extends Equatable {
  const HomePagePostsState();

  @override
  List<Object> get props => [];
}

final class HomePagePostsInitial extends HomePagePostsState {}

class HomePagePostsLoading extends HomePagePostsState {}

class HomePagePostsLoaded extends HomePagePostsState {
  final List<PostModel> posts;

  const HomePagePostsLoaded({required this.posts});
  @override
  List<Object> get props => [posts];
}

class HomePagePostsFailure extends HomePagePostsState {}

class HomePagePostsEmpty extends HomePagePostsState {}
