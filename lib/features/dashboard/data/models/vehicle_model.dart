import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/vehicle_entity.dart';

part 'vehicle_model.g.dart';

@JsonSerializable()
class VehicleModel extends VehicleEntity {
  const VehicleModel({
    required super.id,
    required super.name,
    required super.model,
    required super.plateNumber,
    required super.status,
    required super.daysSinceService,
    required super.milesToMaintenance,
    super.imageUrl,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleModelFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleModelToJson(this);
}
