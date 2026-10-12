import '../../domain/entities/garage_vehicle_entity.dart';
import '../../domain/repositories/garage_repository.dart';
import '../datasources/garage_remote_data_source.dart';
import '../models/garage_vehicle_model.dart';
import '../../../../core/network/error_handler.dart';

class GarageRepositoryImpl implements GarageRepository {
  final GarageRemoteDataSource remoteDataSource;

  GarageRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addVehicle(GarageVehicleEntity vehicle) async {
    try {
      final model = GarageVehicleModel(
        id: vehicle.id,
        type: vehicle.type,
        make: vehicle.make,
        model: vehicle.model,
        year: vehicle.year,
        licensePlate: vehicle.licensePlate,
        expiryDate: vehicle.expiryDate,
        photoPath: vehicle.photoPath,
      );
      await remoteDataSource.addVehicle(model);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
