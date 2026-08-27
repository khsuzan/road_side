// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceItemModel _$ServiceItemModelFromJson(Map<String, dynamic> json) =>
    ServiceItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      estimatedTime: json['estimatedTime'] as String,
      iconName: json['iconName'] as String,
    );

Map<String, dynamic> _$ServiceItemModelToJson(ServiceItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'estimatedTime': instance.estimatedTime,
      'iconName': instance.iconName,
    };
