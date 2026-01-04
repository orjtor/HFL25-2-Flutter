import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:v05_firebase/auth/cubit/auth_state.dart';
import 'package:v05_firebase/auth/repository/auth_repository.dart';
import 'package:v05_firebase/services/analytics_service.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final AnalyticsService _analytics = AnalyticsService();
  late final StreamSubscription<User?> _authStateSubscription;

  AuthCubit(this._authRepository) : super(AuthInitial()) {
    _authStateSubscription = _authRepository.authStateChanges.listen((user) {
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _authRepository.signIn(email: email, password: password);
      await _analytics.logLogin('email');
    } catch (e) {
      emit(AuthError(e.toString().replaceAll('Exception: ', '')));
      // Återgå till unauthenticated state efter kort tid
      await Future.delayed(const Duration(seconds: 3));
      if (state is AuthError) {
        emit(AuthUnauthenticated());
      }
    }
  }

  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
      await _analytics.logLogout();
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription.cancel();
    return super.close();
  }
}
