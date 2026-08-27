import '../../domain/entities/job_detail_entity.dart';
import '../../domain/repositories/mechanic_job_repository.dart';
import '../datasources/mechanic_job_remote_data_source.dart';
import '../../../../core/network/error_handler.dart';

class MechanicJobRepositoryImpl implements MechanicJobRepository {
  final MechanicJobRemoteDataSource remoteDataSource;

  MechanicJobRepositoryImpl({required this.remoteDataSource});

  @override
  Future<JobDetailEntity> getJobDetails(String jobId) async {
    try {
      return await remoteDataSource.getJobDetails(jobId);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  @override
  Future<void> completeJob({
    required String jobId,
    required String verificationPin,
    required double laborCharge,
    required double partsUsed,
  }) async {
    try {
      await remoteDataSource.completeJob(
        jobId,
        verificationPin,
        laborCharge,
        partsUsed,
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
