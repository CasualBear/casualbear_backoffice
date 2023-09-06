import 'package:casualbear_backoffice/network/models/answer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

@JsonSerializable()
class Question {
  final int id;
  final String question;
  final List<Answer>? answers;
  final int correctAnswerIndex;
  final int points;
  final bool isVisible;
  final String zone;
  final String latitude;
  final String longitude;
  final String address;
  final String createdAt;
  final String updatedAt;
  final int eventId;

  Question({
    required this.id,
    required this.question,
    required this.answers,
    required this.correctAnswerIndex,
    required this.points,
    required this.isVisible,
    required this.zone,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
    required this.eventId,
  });

  factory Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}
