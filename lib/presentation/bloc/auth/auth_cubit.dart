import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';
import '../../../repo/auth_repo.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial()) {
    checkAuthStatus();
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      await _authRepository.signInWithGoogle();
      final user = _authRepository.currentUser;
      if (user != null) {
        emit(Authenticated(user.email!));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    emit(Unauthenticated());
  }

  void checkAuthStatus() {
    final user = _authRepository.currentUser;
    if (user != null) {
      emit(Authenticated(user.email!));
    } else {
      emit(Unauthenticated());
    }
  }
}
