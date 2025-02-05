part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class LoadingState extends AuthState {}

final class LoadedState extends AuthState {}

final class VerifiedState extends AuthState {}

final class SignupSuccess extends AuthState {}

final class LoginsuccessState extends AuthState{}

final class PendingState extends AuthState{}

final class BlockedState extends AuthState{}

class DriverRegistrationSuccess extends AuthState {}


final class ErrorState extends AuthState {
  final String message;

  ErrorState({required this.message});
}


class AuthenticatedState extends AuthState{}

class UnauthenticatedState extends AuthState{}

