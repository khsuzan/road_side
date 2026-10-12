class GarageVehicleEntity {
  final String id;
  final String type; // 'Car', 'Motorcycle', 'Truck', 'EV'
  final String make;
  final String model;
  final int year;
  final String licensePlate;
  final String expiryDate; // 'YYYY-MM'
  final String? photoPath;

  const GarageVehicleEntity({
    required this.id,
    required this.type,
    required this.make,
    required this.model,
    required this.year,
    required this.licensePlate,
    required this.expiryDate,
    this.photoPath,
  });
}
