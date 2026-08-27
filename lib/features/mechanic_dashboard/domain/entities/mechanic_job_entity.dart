class MechanicJobEntity {
  final String id;
  final String title;
  final String vehicleModel;
  final String description;
  final String status; // 'Repairing', 'En Route', 'Diagnosing'
  final String timestamp;
  final String? imageUrl;

  const MechanicJobEntity({
    required this.id,
    required this.title,
    required this.vehicleModel,
    required this.description,
    required this.status,
    required this.timestamp,
    this.imageUrl,
  });
}
