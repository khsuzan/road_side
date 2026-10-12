// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'garage_vehicle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GarageVehicleModel _$GarageVehicleModelFromJson(Map<String, dynamic> json) =>
    GarageVehicleModel(
      id: json['id'] as String,
      type: json['type'] as String,
      make: json['make'] as String,
      model: json['model'] as String,
      year: (json['year'] as num).toInt(),
      licensePlate: json['licensePlate'] as String,
      expiryDate: json['expiryDate'] as String,
      photoPath: json['photoPath'] as String?,
    );

Map<String, dynamic> _$GarageVehicleModelToJson(GarageVehicleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'make': instance.make,
      'model': instance.model,
      'year': instance.year,
      'licensePlate': instance.licensePlate,
      'expiryDate': instance.expiryDate,
      'photoPath': instance.photoPath,
    };
