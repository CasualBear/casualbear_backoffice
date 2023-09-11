// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      selectedColor: json['selectedColor'] as int,
      hasStarted: json['hasStarted'] as String,
      rawUrl: json['rawUrl'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'selectedColor': instance.selectedColor,
      'rawUrl': instance.rawUrl,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'hasStarted': instance.hasStarted,
    };
