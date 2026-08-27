// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleModel _$VehicleModelFromJson(Map<String, dynamic> json) => VehicleModel(
  id: json['id'] as String,
  name: json['name'] as String,
  model: json['model'] as String,
  plateNumber: json['plateNumber'] as String,
  status: json['status'] as String,
  daysSinceService: (json['daysSinceService'] as num).toInt(),
  milesToMaintenance: (json['milesToMaintenance'] as num).toDouble(),
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$VehicleModelToJson(VehicleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'model': instance.model,
      'plateNumber': instance.plateNumber,
      'status': instance.status,
      'daysSinceService': instance.daysSinceService,
      'milesToMaintenance': instance.milesToMaintenance,
      'imageUrl': instance.imageUrl,
    };
