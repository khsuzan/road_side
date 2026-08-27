import '../entities/mechanic_job_entity.dart';

abstract class MechanicDashboardRepository {
  Future<List<MechanicJobEntity>> getOngoingJobs();
}
