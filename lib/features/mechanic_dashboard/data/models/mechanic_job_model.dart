import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/mechanic_job_entity.dart';

part 'mechanic_job_model.g.dart';

@JsonSerializable()
class MechanicJobModel extends MechanicJobEntity {
  const MechanicJobModel({
    required super.id,
    required super.title,
    required super.vehicleModel,
    required super.description,
    required super.status,
    required super.timestamp,
    super.imageUrl,
  });

  factory MechanicJobModel.fromJson(Map<String, dynamic> json) =>
      _$MechanicJobModelFromJson(json);

  Map<String, dynamic> toJson() => _$MechanicJobModelToJson(this);
}
