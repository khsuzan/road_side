abstract class MechanicJobEvent {
  const MechanicJobEvent();
}

class FetchJobDetailEvent extends MechanicJobEvent {
  final String jobId;
  const FetchJobDetailEvent(this.jobId);
}

class SubmitCompleteJobEvent extends MechanicJobEvent {
  final String jobId;
  final String verificationPin;
  final double laborCharge;
  final double partsUsed;

  const SubmitCompleteJobEvent({
    required this.jobId,
    required this.verificationPin,
    required this.laborCharge,
    required this.partsUsed,
  });
}
