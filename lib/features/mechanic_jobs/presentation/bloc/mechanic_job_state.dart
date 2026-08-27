import '../../domain/entities/job_detail_entity.dart';

abstract class MechanicJobState {
  const MechanicJobState();
}

class MechanicJobInitial extends MechanicJobState {
  const MechanicJobInitial();
}

class MechanicJobLoading extends MechanicJobState {
  const MechanicJobLoading();
}

class MechanicJobDetailSuccess extends MechanicJobState {
  final JobDetailEntity job;
  const MechanicJobDetailSuccess(this.job);
}

class MechanicJobCompleteSuccess extends MechanicJobState {
  const MechanicJobCompleteSuccess();
}

class MechanicJobFailure extends MechanicJobState {
  final String message;
  const MechanicJobFailure(this.message);
}
