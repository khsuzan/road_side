import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/job_detail_entity.dart';

part 'job_detail_model.g.dart';

@JsonSerializable()
class JobDetailModel extends JobDetailEntity {
  const JobDetailModel({
    required super.id,
    required super.customerName,
    super.customerAvatarUrl,
    required super.location,
    required super.etaText,
    required super.reportedIssues,
    required super.audioDurationText,
    required super.evidencePhotoUrls,
    required super.status,
    required super.laborCharge,
    required super.partsUsed,
    required super.verificationPin,
  });

  factory JobDetailModel.fromJson(Map<String, dynamic> json) =>
      _$JobDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$JobDetailModelToJson(this);
}
