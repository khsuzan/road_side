import '../../domain/entities/service_item_entity.dart';
import '../../domain/repositories/service_repository.dart';
import '../datasources/service_remote_data_source.dart';
import '../../../../core/network/error_handler.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceRemoteDataSource remoteDataSource;

  ServiceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ServiceItemEntity>> getServices(String category) async {
    try {
      return await remoteDataSource.getServices(category);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  @override
  Future<void> submitServiceRequest({
    required List<String> issues,
    required String serviceType,
    String? audioPath,
  }) async {
    try {
      await remoteDataSource.submitRequest(
        issues: issues,
        serviceType: serviceType,
        audioPath: audioPath,
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
