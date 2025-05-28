import 'package:crm_application/data/repository/auth_repository.dart';
import 'package:crm_application/shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await _authRepository.signIn(event.email, event.password);

      // Save to local storage
      // Save UID and role to preferences
      final prefs = Preferences();
      await prefs.saveUserId(result['uid']);
      await prefs.saveUserRole(result['role']);


      emit(AuthAuthenticated(uid: result['uid'], role: result['role']));
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<AuthState> emit) async {
    await _authRepository.signOut();
    await Preferences().clearAll(); // Clear session
    emit(AuthInitial());
  }
}
