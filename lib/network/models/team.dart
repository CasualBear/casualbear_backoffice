import 'dart:convert';

import 'package:casualbear_backoffice/network/models/user.dart';
import 'package:casualbear_backoffice/network/models/zones.dart';
import 'package:json_annotation/json_annotation.dart';

part 'team.g.dart';

@JsonSerializable()
class Team {
  final int id;
  final int totalPoints;
  final String name;
  final String isVerified;
  final bool isCheckedOverall;
  final List<Zones> zones;
  final int timeSpent;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int eventId;
  final List<User> members;

  Team({
    required this.id,
    required this.totalPoints,
    required this.timeSpent,
    required this.isVerified,
    required this.name,
    required this.members,
    required this.isCheckedOverall,
    required this.zones,
    required this.createdAt,
    required this.updatedAt,
    required this.eventId,
  });

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);

  Map<String, dynamic> toJson() => _$TeamToJson(this);
}
