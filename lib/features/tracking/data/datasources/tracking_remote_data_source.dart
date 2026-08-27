import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../models/tracking_status_model.dart';

part 'tracking_remote_data_source.g.dart';

@RestApi()
abstract class TrackingRemoteDataSource {
  factory TrackingRemoteDataSource(Dio dio, {String baseUrl}) =
      _TrackingRemoteDataSource;

  @GET('tracking/{requestId}')
  Future<TrackingStatusModel> getTrackingStatus(
    @Path('requestId') String requestId,
  );
}
