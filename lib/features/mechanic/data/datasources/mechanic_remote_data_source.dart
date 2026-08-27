import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../models/mechanic_application_model.dart';

part 'mechanic_remote_data_source.g.dart';

@RestApi()
abstract class MechanicRemoteDataSource {
  factory MechanicRemoteDataSource(Dio dio, {String baseUrl}) =
      _MechanicRemoteDataSource;

  @POST('mechanic/apply')
  Future<void> submitApplication(
    @Body() MechanicApplicationModel application,
  );

  @GET('mechanic/status/{id}')
  Future<String> getApplicationStatus(@Path('id') String mechanicId);
}
