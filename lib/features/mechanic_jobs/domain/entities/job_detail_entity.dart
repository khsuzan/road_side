class JobDetailEntity {
  final String id;
  final String customerName;
  final String? customerAvatarUrl;
  final String location;
  final String etaText;
  final List<String> reportedIssues;
  final String audioDurationText;
  final List<String> evidencePhotoUrls;
  final String status; // 'Dispatched', 'En Route', 'Arrived', 'Repairing'
  final double laborCharge;
  final double partsUsed;
  final String verificationPin;

  const JobDetailEntity({
    required this.id,
    required this.customerName,
    this.customerAvatarUrl,
    required this.location,
    required this.etaText,
    required this.reportedIssues,
    required this.audioDurationText,
    required this.evidencePhotoUrls,
    required this.status,
    required this.laborCharge,
    required this.partsUsed,
    required this.verificationPin,
  });
}
