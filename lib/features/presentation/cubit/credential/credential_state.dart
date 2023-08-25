part of 'credential_cubit.dart';

abstract class CredentialState extends Equatable {
  const CredentialState();

  @override
  List<Object> get props => [];
}

class CredentialInitial extends CredentialState {}

class CredentialLoading extends CredentialState {}

class CredentialSuccess extends CredentialState {}

class CredentialFailure extends CredentialState {}
