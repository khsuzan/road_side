abstract class AuthEvent {
  const AuthEvent();
}

class SendOtpEvent extends AuthEvent {
  final String phoneNumber;
  const SendOtpEvent(this.phoneNumber);
}

class VerifyOtpEvent extends AuthEvent {
  final String phoneNumber;
  final String code;
  const VerifyOtpEvent(this.phoneNumber, this.code);
}

class ResetAuthEvent extends AuthEvent {
  const ResetAuthEvent();
}
