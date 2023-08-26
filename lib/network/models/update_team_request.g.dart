// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_team_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateTeamRequest _$UpdateTeamRequestFromJson(Map<String, dynamic> json) =>
    UpdateTeamRequest(
      teamId: json['teamId'] as int,
      isCheckedIn: json['isCheckedIn'] as bool,
      isVerified: json['isVerified'] as String,
    );

Map<String, dynamic> _$UpdateTeamRequestToJson(UpdateTeamRequest instance) =>
    <String, dynamic>{
      'teamId': instance.teamId,
      'isVerified': instance.isVerified,
      'isCheckedIn': instance.isCheckedIn,
    };
