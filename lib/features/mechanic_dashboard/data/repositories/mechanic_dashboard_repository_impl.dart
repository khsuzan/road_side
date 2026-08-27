import '../../domain/entities/mechanic_job_entity.dart';
import '../../domain/repositories/mechanic_dashboard_repository.dart';
import '../datasources/mechanic_dashboard_remote_data_source.dart';
import '../../../../core/network/error_handler.dart';

class MechanicDashboardRepositoryImpl implements MechanicDashboardRepository {
  final MechanicDashboardRemoteDataSource remoteDataSource;

  MechanicDashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<MechanicJobEntity>> getOngoingJobs() async {
    try {
      return await remoteDataSource.getOngoingJobs();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
