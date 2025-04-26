import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];

  T? maybeWhen<T>({
    T Function(User)? authenticated,
    T Function()? unauthenticated,
    T Function()? loading,
    T Function(String)? error,
    T Function()? orElse,
  }) {
    if (this is Authenticated && authenticated != null) {
      return authenticated((this as Authenticated).user);
    } else if (this is Unauthenticated && unauthenticated != null) {
      return unauthenticated();
    } else if (this is AuthLoading && loading != null) {
      return loading();
    } else if (this is AuthError && error != null) {
      return error((this as AuthError).message);
    } else if (orElse != null) {
      return orElse();
    }
    return null;
  }
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
