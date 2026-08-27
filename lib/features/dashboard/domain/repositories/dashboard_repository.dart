import '../entities/vehicle_entity.dart';

abstract class DashboardRepository {
  Future<VehicleEntity> getActiveVehicle();
}
