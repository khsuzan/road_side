// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobDetailModel _$JobDetailModelFromJson(Map<String, dynamic> json) =>
    JobDetailModel(
      id: json['id'] as String,
      customerName: json['customerName'] as String,
      customerAvatarUrl: json['customerAvatarUrl'] as String?,
      location: json['location'] as String,
      etaText: json['etaText'] as String,
      reportedIssues: (json['reportedIssues'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      audioDurationText: json['audioDurationText'] as String,
      evidencePhotoUrls: (json['evidencePhotoUrls'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      status: json['status'] as String,
      laborCharge: (json['laborCharge'] as num).toDouble(),
      partsUsed: (json['partsUsed'] as num).toDouble(),
      verificationPin: json['verificationPin'] as String,
    );

Map<String, dynamic> _$JobDetailModelToJson(JobDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerName': instance.customerName,
      'customerAvatarUrl': instance.customerAvatarUrl,
      'location': instance.location,
      'etaText': instance.etaText,
      'reportedIssues': instance.reportedIssues,
      'audioDurationText': instance.audioDurationText,
      'evidencePhotoUrls': instance.evidencePhotoUrls,
      'status': instance.status,
      'laborCharge': instance.laborCharge,
      'partsUsed': instance.partsUsed,
      'verificationPin': instance.verificationPin,
    };
