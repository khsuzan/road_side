import '../../domain/entities/vehicle_entity.dart';

abstract class DashboardState {
  const DashboardState();
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardSuccess extends DashboardState {
  final VehicleEntity vehicle;
  const DashboardSuccess(this.vehicle);
}

class DashboardFailure extends DashboardState {
  final String message;
  const DashboardFailure(this.message);
}
