import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../models/mechanic_job_model.dart';

part 'mechanic_dashboard_remote_data_source.g.dart';

@RestApi()
abstract class MechanicDashboardRemoteDataSource {
  factory MechanicDashboardRemoteDataSource(Dio dio, {String baseUrl}) =
      _MechanicDashboardRemoteDataSource;

  @GET('mechanic/jobs')
  Future<List<MechanicJobModel>> getOngoingJobs();
}
