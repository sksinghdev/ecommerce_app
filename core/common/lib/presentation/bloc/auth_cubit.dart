 import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/service/firebase_service.dart';
import 'auth_state.dart';
 


class AuthCubit extends Cubit<AuthState> {
  final FirebaseService _service;
  AuthCubit(this._service) : super(AuthInitial());

  void checkAuthStatus() {
    final user = _service.currentUser;
    if (user != null) {
      emit(Authenticated());
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      await _service.signInWithEmail(email, password);
      emit(Authenticated());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> signUp(String email, String password) async {
    emit(AuthLoading());
    try {
      await _service.signUpWithEmail(email, password);
      emit(Authenticated());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      await _service.signInWithGoogle();
      emit(Authenticated());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> signOut() async {
    await _service.signOut();
    emit(Unauthenticated());
  }
}