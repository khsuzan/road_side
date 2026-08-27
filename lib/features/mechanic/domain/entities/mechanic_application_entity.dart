class MechanicApplicationEntity {
  final String id;
  final String? idPhotoPath;
  final List<String> expertise;
  final String businessType; // 'Mobile Freelancer' or 'Garage Owner'
  final double latitude;
  final double longitude;
  final String status; // 'Pending', 'Approved', 'Rejected'

  const MechanicApplicationEntity({
    required this.id,
    this.idPhotoPath,
    required this.expertise,
    required this.businessType,
    required this.latitude,
    required this.longitude,
    required this.status,
  });
}
