// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mechanic_application_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MechanicApplicationModel _$MechanicApplicationModelFromJson(
  Map<String, dynamic> json,
) => MechanicApplicationModel(
  id: json['id'] as String,
  idPhotoPath: json['idPhotoPath'] as String?,
  expertise: (json['expertise'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  businessType: json['businessType'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  status: json['status'] as String,
);

Map<String, dynamic> _$MechanicApplicationModelToJson(
  MechanicApplicationModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'idPhotoPath': instance.idPhotoPath,
  'expertise': instance.expertise,
  'businessType': instance.businessType,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'status': instance.status,
};
