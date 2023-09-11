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
  final String hasStarted;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.selectedColor,
    required this.hasStarted,
    required this.rawUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);
}
