part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UsersLoaded extends UserState {
  final List<UserModel> users;

  const UsersLoaded({required this.users});

  @override
  List<Object> get props => [users];
}

class UserFailure extends UserState {}
