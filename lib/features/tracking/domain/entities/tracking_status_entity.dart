class TrackingStatusEntity {
  final String requestId;
  final int etaMinutes;
  final double distanceMiles;
  final String mechanicName;
  final double mechanicRating;
  final String? mechanicAvatarUrl;
  final String vanModel;
  final String plateNumber;
  final String verificationPin;
  final String currentStep; // 'Dispatched', 'En Route', 'Arrived', 'Repairing'

  const TrackingStatusEntity({
    required this.requestId,
    required this.etaMinutes,
    required this.distanceMiles,
    required this.mechanicName,
    required this.mechanicRating,
    this.mechanicAvatarUrl,
    required this.vanModel,
    required this.plateNumber,
    required this.verificationPin,
    required this.currentStep,
  });
}
