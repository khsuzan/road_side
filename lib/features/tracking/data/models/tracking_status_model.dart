import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/tracking_status_entity.dart';

part 'tracking_status_model.g.dart';

@JsonSerializable()
class TrackingStatusModel extends TrackingStatusEntity {
  const TrackingStatusModel({
    required super.requestId,
    required super.etaMinutes,
    required super.distanceMiles,
    required super.mechanicName,
    required super.mechanicRating,
    super.mechanicAvatarUrl,
    required super.vanModel,
    required super.plateNumber,
    required super.verificationPin,
    required super.currentStep,
  });

  factory TrackingStatusModel.fromJson(Map<String, dynamic> json) =>
      _$TrackingStatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$TrackingStatusModelToJson(this);
}
