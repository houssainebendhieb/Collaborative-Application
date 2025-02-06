part of 'user_cubit.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class UserLoginLoading extends UserState {}

final class UserLoginFailure extends UserState {
  final String errorMessage;
  UserLoginFailure({required this.errorMessage});
}

final class UserSignUpLoading extends UserState {}

final class UserSignUpFailure extends UserState {
  final String errorMessage;
  UserSignUpFailure({required this.errorMessage});
}
