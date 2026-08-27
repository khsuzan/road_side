abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class OtpSentState extends AuthState {
  final String phoneNumber;
  const OtpSentState(this.phoneNumber);
}

class AuthSuccess extends AuthState {
  final String token;
  const AuthSuccess(this.token);
}

class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
}
