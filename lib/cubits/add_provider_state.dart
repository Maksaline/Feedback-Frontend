part of 'add_provider_cubit.dart';

@immutable
sealed class AddProviderState {}

final class AddProviderInitial extends AddProviderState {}

final class AddProviderLoading extends AddProviderState {}

final class AddProviderSuccess extends AddProviderState {
  final String message;

  AddProviderSuccess(this.message);
}

final class AddProviderFailure extends AddProviderState {
  final String error;

  AddProviderFailure(this.error);
}