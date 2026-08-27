import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../models/job_detail_model.dart';

part 'mechanic_job_remote_data_source.g.dart';

@RestApi()
abstract class MechanicJobRemoteDataSource {
  factory MechanicJobRemoteDataSource(Dio dio, {String baseUrl}) =
      _MechanicJobRemoteDataSource;

  @GET('mechanic/job/{id}')
  Future<JobDetailModel> getJobDetails(@Path('id') String jobId);

  @POST('mechanic/job/{id}/complete')
  Future<void> completeJob(
    @Path('id') String jobId,
    @Field('verificationPin') String verificationPin,
    @Field('laborCharge') double laborCharge,
    @Field('partsUsed') double partsUsed,
  );
}
