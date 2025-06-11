import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/user_model.dart';
import '../../data/repository/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  Future<void> loginWithEmail(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signInWithEmail(email, password);
      emit(Authenticated(UserModel.fromFirebaseUser(user!)));
    } catch (e) {
      emit(Unauthenticated(message: e.toString()));
    }
  }

  Future<void> loginWithGoogle() async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signInWithGoogle();
      emit(Authenticated(UserModel.fromFirebaseUser(user!)));
    } catch (e) {
      emit(Unauthenticated(message: e.toString()));
    }
  }

  Future<void> logout() async {
    await _authRepository.signOut();
    emit(Unauthenticated());
  }
}
