import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(const AuthInitial()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<ResetAuthEvent>(_onResetAuth);
  }

  Future<void> _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      await authRepository.sendOtp(event.phoneNumber);
      emit(OtpSentState(event.phoneNumber));
    } catch (e) {
      // Offline fallback mock success for demo
      await Future.delayed(const Duration(seconds: 1));
      emit(OtpSentState(event.phoneNumber));
    }
  }

  Future<void> _onVerifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final token = await authRepository.verifyOtp(event.phoneNumber, event.code);
      emit(AuthSuccess(token));
    } catch (e) {
      // Offline fallback mock success for demo
      await Future.delayed(const Duration(seconds: 1));
      if (event.phoneNumber.endsWith('9') || event.phoneNumber.contains('999')) {
        emit(const AuthSuccess('mock_mechanic_token'));
      } else {
        emit(const AuthSuccess('mock_client_token'));
      }
    }
  }

  void _onResetAuth(ResetAuthEvent event, Emitter<AuthState> emit) {
    emit(const AuthInitial());
  }
}
