abstract class AuthRepository {
  Future<void> sendOtp(String phoneNumber);
  Future<String> verifyOtp(String phoneNumber, String code);
}
