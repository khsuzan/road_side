import '../entities/job_detail_entity.dart';

abstract class MechanicJobRepository {
  Future<JobDetailEntity> getJobDetails(String jobId);
  Future<void> completeJob({
    required String jobId,
    required String verificationPin,
    required double laborCharge,
    required double partsUsed,
  });
}
