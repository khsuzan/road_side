class VehicleEntity {
  final String id;
  final String name;
  final String model;
  final String plateNumber;
  final String status;
  final int daysSinceService;
  final double milesToMaintenance;
  final String? imageUrl;

  const VehicleEntity({
    required this.id,
    required this.name,
    required this.model,
    required this.plateNumber,
    required this.status,
    required this.daysSinceService,
    required this.milesToMaintenance,
    this.imageUrl,
  });
}
