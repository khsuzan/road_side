// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mechanic_job_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MechanicJobModel _$MechanicJobModelFromJson(Map<String, dynamic> json) =>
    MechanicJobModel(
      id: json['id'] as String,
      title: json['title'] as String,
      vehicleModel: json['vehicleModel'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      timestamp: json['timestamp'] as String,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$MechanicJobModelToJson(MechanicJobModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'vehicleModel': instance.vehicleModel,
      'description': instance.description,
      'status': instance.status,
      'timestamp': instance.timestamp,
      'imageUrl': instance.imageUrl,
    };
