part of 'sign_up_cubit.dart';

@immutable
sealed class SignUpState {}

final class SignUpInitial extends SignUpState {}
final class SignUpLoading extends SignUpState {}
final class SignUpSuccess extends SignUpState {
  final String message;

  SignUpSuccess(this.message);
}

final class SignUpFailure extends SignUpState {
  final String error;

  SignUpFailure(this.error);
}