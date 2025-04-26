import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/services/auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;

  AuthCubit(this._authService) : super(const AuthState.initial()) {
    _authService.authStateChanges.listen((user) {
      if (user != null) {
        emit(AuthState.authenticated(user));
      } else {
        emit(const AuthState.unauthenticated());
      }
    });
  }

  Future<void> signInWithGoogle() async {
    try {
      emit(const AuthState.loading());
      await _authService.signInWithGoogle();
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      emit(const AuthState.loading());
      await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      emit(const AuthState.loading());
      await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      );
      await _authService.sendEmailVerification();
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      emit(const AuthState.loading());
      await _authService.signOut();
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      emit(const AuthState.loading());
      await _authService.resetPassword(email);
      emit(const AuthState.unauthenticated());
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> checkEmailVerification() async {
    try {
      final isVerified = await _authService.isEmailVerified();
      if (!isVerified) {
        emit(AuthState.error('Please verify your email address'));
      }
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> resendVerificationEmail() async {
    try {
      emit(const AuthState.loading());
      await _authService.sendEmailVerification();
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> updateProfile({
    String? displayName,
    String? photoURL,
    String? phoneNumber,
  }) async {
    try {
      emit(const AuthState.loading());
      await _authService.updateUserProfile(
        displayName: displayName,
        photoURL: photoURL,
        phoneNumber: phoneNumber,
      );
      final currentState = state;
      if (currentState is AuthState) {
        final user = currentState.maybeWhen(
          authenticated: (user) => user,
          orElse: () => null,
        );
        if (user != null) {
          emit(AuthState.authenticated(user));
        }
      }
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> changePassword(String newPassword) async {
    try {
      emit(const AuthState.loading());
      await _authService.changePassword(newPassword);
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> reauthenticate(String password) async {
    try {
      emit(const AuthState.loading());
      await _authService.reauthenticate(password);
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> deleteAccount() async {
    try {
      emit(const AuthState.loading());
      await _authService.deleteAccount();
      emit(const AuthState.unauthenticated());
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }
}
