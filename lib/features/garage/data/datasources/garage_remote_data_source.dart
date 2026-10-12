import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../models/garage_vehicle_model.dart';

part 'garage_remote_data_source.g.dart';

@RestApi()
abstract class GarageRemoteDataSource {
  factory GarageRemoteDataSource(Dio dio, {String baseUrl}) =
      _GarageRemoteDataSource;

  @POST('garage/add')
  Future<void> addVehicle(@Body() GarageVehicleModel vehicle);
}
