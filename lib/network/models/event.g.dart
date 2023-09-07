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
      hasStarted: json['hasStarted'] as bool,
      rawUrl: json['rawUrl'] as String,
      teams: (json['teams'] as List<dynamic>?)
          ?.map((e) => Team.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      questions: (json['questions'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'selectedColor': instance.selectedColor,
      'rawUrl': instance.rawUrl,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'questions': instance.questions,
      'hasStarted': instance.hasStarted,
      'teams': instance.teams,
    };
