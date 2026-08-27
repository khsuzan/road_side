import '../../domain/entities/vehicle_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_data_source.dart';
import '../../../../core/network/error_handler.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<VehicleEntity> getActiveVehicle() async {
    try {
      return await remoteDataSource.getActiveVehicle();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
