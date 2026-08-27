// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackingStatusModel _$TrackingStatusModelFromJson(Map<String, dynamic> json) =>
    TrackingStatusModel(
      requestId: json['requestId'] as String,
      etaMinutes: (json['etaMinutes'] as num).toInt(),
      distanceMiles: (json['distanceMiles'] as num).toDouble(),
      mechanicName: json['mechanicName'] as String,
      mechanicRating: (json['mechanicRating'] as num).toDouble(),
      mechanicAvatarUrl: json['mechanicAvatarUrl'] as String?,
      vanModel: json['vanModel'] as String,
      plateNumber: json['plateNumber'] as String,
      verificationPin: json['verificationPin'] as String,
      currentStep: json['currentStep'] as String,
    );

Map<String, dynamic> _$TrackingStatusModelToJson(
  TrackingStatusModel instance,
) => <String, dynamic>{
  'requestId': instance.requestId,
  'etaMinutes': instance.etaMinutes,
  'distanceMiles': instance.distanceMiles,
  'mechanicName': instance.mechanicName,
  'mechanicRating': instance.mechanicRating,
  'mechanicAvatarUrl': instance.mechanicAvatarUrl,
  'vanModel': instance.vanModel,
  'plateNumber': instance.plateNumber,
  'verificationPin': instance.verificationPin,
  'currentStep': instance.currentStep,
};
