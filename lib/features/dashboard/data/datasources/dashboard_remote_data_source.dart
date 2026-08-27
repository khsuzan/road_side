import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../models/vehicle_model.dart';

part 'dashboard_remote_data_source.g.dart';

@RestApi()
abstract class DashboardRemoteDataSource {
  factory DashboardRemoteDataSource(Dio dio, {String baseUrl}) =
      _DashboardRemoteDataSource;

  @GET('dashboard/active-vehicle')
  Future<VehicleModel> getActiveVehicle();
}
