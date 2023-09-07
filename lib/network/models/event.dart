import 'package:casualbear_backoffice/network/models/question.dart';
import 'package:casualbear_backoffice/network/models/team.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable()
class Event {
  final int id;
  final String name;
  final String description;
  final int selectedColor;
  final String rawUrl;
  final String createdAt;
  final String updatedAt;
  final List<Question> questions;
  final bool hasStarted;
  final List<Team>? teams;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.selectedColor,
    required this.hasStarted,
    required this.rawUrl,
    required this.teams,
    required this.createdAt,
    required this.updatedAt,
    required this.questions,
  });

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);
}
