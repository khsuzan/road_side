import '../entities/garage_vehicle_entity.dart';

abstract class GarageRepository {
  Future<void> addVehicle(GarageVehicleEntity vehicle);
}
