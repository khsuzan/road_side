import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../models/service_item_model.dart';

part 'service_remote_data_source.g.dart';

@RestApi()
abstract class ServiceRemoteDataSource {
  factory ServiceRemoteDataSource(Dio dio, {String baseUrl}) =
      _ServiceRemoteDataSource;

  @GET('services')
  Future<List<ServiceItemModel>> getServices(@Query('category') String category);

  @POST('services/request')
  Future<void> submitRequest({
    @Field('issues') required List<String> issues,
    @Field('serviceType') required String serviceType,
    @Field('audioPath') String? audioPath,
  });
}
