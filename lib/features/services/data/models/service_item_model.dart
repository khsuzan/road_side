import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/service_item_entity.dart';

part 'service_item_model.g.dart';

@JsonSerializable()
class ServiceItemModel extends ServiceItemEntity {
  const ServiceItemModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.estimatedTime,
    required super.iconName,
  });

  factory ServiceItemModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceItemModelToJson(this);
}
