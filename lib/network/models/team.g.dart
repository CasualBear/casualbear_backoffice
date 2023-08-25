// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Team _$TeamFromJson(Map<String, dynamic> json) => Team(
      id: json['id'] as int,
      totalPoints: json['totalPoints'] as int,
      timeSpent: json['timeSpent'] as int,
      isVerified: json['isVerified'] as String,
      name: json['name'] as String,
      members: (json['members'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      isCheckedOverall: json['isCheckedOverall'] as bool,
      zones: (json['zones'] as List<dynamic>)
          .map((e) => Zones.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      eventId: json['eventId'] as int,
    );

Map<String, dynamic> _$TeamToJson(Team instance) => <String, dynamic>{
      'id': instance.id,
      'totalPoints': instance.totalPoints,
      'name': instance.name,
      'isVerified': instance.isVerified,
      'isCheckedOverall': instance.isCheckedOverall,
      'zones': instance.zones,
      'timeSpent': instance.timeSpent,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'eventId': instance.eventId,
      'members': instance.members,
    };
