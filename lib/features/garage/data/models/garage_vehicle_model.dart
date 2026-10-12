import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/garage_vehicle_entity.dart';

part 'garage_vehicle_model.g.dart';

@JsonSerializable()
class GarageVehicleModel extends GarageVehicleEntity {
  const GarageVehicleModel({
    required super.id,
    required super.type,
    required super.make,
    required super.model,
    required super.year,
    required super.licensePlate,
    required super.expiryDate,
    super.photoPath,
  });

  factory GarageVehicleModel.fromJson(Map<String, dynamic> json) =>
      _$GarageVehicleModelFromJson(json);

  Map<String, dynamic> toJson() => _$GarageVehicleModelToJson(this);
}
