import '../../domain/entities/garage_vehicle_entity.dart';

abstract class GarageEvent {
  const GarageEvent();
}

class AddVehicleEvent extends GarageEvent {
  final GarageVehicleEntity vehicle;
  const AddVehicleEvent(this.vehicle);
}
