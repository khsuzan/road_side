import '../../domain/entities/mechanic_job_entity.dart';

abstract class MechanicDashboardState {
  const MechanicDashboardState();
}

class MechanicDashboardInitial extends MechanicDashboardState {
  const MechanicDashboardInitial();
}

class MechanicDashboardLoading extends MechanicDashboardState {
  const MechanicDashboardLoading();
}

class MechanicDashboardSuccess extends MechanicDashboardState {
  final List<MechanicJobEntity> jobs;
  const MechanicDashboardSuccess(this.jobs);
}

class MechanicDashboardFailure extends MechanicDashboardState {
  final String message;
  const MechanicDashboardFailure(this.message);
}
