import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/mechanic_application_entity.dart';

part 'mechanic_application_model.g.dart';

@JsonSerializable()
class MechanicApplicationModel extends MechanicApplicationEntity {
  const MechanicApplicationModel({
    required super.id,
    super.idPhotoPath,
    required super.expertise,
    required super.businessType,
    required super.latitude,
    required super.longitude,
    required super.status,
  });

  factory MechanicApplicationModel.fromJson(Map<String, dynamic> json) =>
      _$MechanicApplicationModelFromJson(json);

  Map<String, dynamic> toJson() => _$MechanicApplicationModelToJson(this);
}
