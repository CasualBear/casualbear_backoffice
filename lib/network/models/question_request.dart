import 'package:casualbear_backoffice/network/models/answer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'question_request.g.dart';

@JsonSerializable()
class QuestionRequest {
  final int id;
  final String question;
  final List<Answer>? answers;
  final int correctAnswerIndex;
  final int points;
  final String zone;
  final String latitude;
  final String longitude;
  final String address;
  final String createdAt;
  final String updatedAt;
  final int eventId;

  QuestionRequest({
    required this.id,
    required this.question,
    required this.answers,
    required this.correctAnswerIndex,
    required this.points,
    required this.zone,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
    required this.eventId,
  });

  factory QuestionRequest.fromJson(Map<String, dynamic> json) => _$QuestionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionRequestToJson(this);
}
