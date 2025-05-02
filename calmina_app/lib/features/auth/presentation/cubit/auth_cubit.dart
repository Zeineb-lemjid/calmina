import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/services/auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;

  AuthCubit(this._authService) : super(AuthInitial()) {
    _authService.authStateChanges.listen((user) {
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      emit(AuthLoading());
      await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'An error occurred'));
    }
  }

  Future<void> signUp(
      String email, String password, String? displayName) async {
    try {
      emit(AuthLoading());
      await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      );
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'An error occurred'));
    }
  }

  Future<void> signOut() async {
    try {
      emit(AuthLoading());
      await _authService.signOut();
    } catch (e) {
      emit(const AuthError('Failed to sign out'));
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      emit(AuthLoading());
      await _authService.resetPassword(email);
      emit(AuthInitial());
    } catch (e) {
      emit(const AuthError('Failed to reset password'));
    }
  }
}
