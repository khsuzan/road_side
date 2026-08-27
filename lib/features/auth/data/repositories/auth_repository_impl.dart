import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../../../../core/network/error_handler.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> sendOtp(String phoneNumber) async {
    try {
      await remoteDataSource.sendOtp(phoneNumber);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  @override
  Future<String> verifyOtp(String phoneNumber, String code) async {
    try {
      final response = await remoteDataSource.verifyOtp(phoneNumber, code);
      return response.token;
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
