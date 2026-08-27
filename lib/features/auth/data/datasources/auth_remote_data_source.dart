import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../models/auth_models.dart';

part 'auth_remote_data_source.g.dart';

@RestApi()
abstract class AuthRemoteDataSource {
  factory AuthRemoteDataSource(Dio dio, {String baseUrl}) = _AuthRemoteDataSource;

  @POST('auth/send-otp')
  Future<void> sendOtp(@Field('phoneNumber') String phoneNumber);

  @POST('auth/verify-otp')
  Future<AuthResponseModel> verifyOtp(
    @Field('phoneNumber') String phoneNumber,
    @Field('code') String code,
  );
}
