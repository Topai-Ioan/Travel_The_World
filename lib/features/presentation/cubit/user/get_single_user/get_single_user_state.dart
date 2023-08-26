part of 'get_single_user_cubit.dart';

abstract class GetSingleUserState extends Equatable {
  const GetSingleUserState();

  @override
  List<Object> get props => [];
}

class GetSingleUserInitial extends GetSingleUserState {}

class GetSingleUserLoading extends GetSingleUserState {}

class GetSingleUserLoaded extends GetSingleUserState {
  final UserEntity user;
  const GetSingleUserLoaded({required this.user});
  @override
  List<Object> get props => [user];
}

class GetSingleUserFailure extends GetSingleUserState {}
